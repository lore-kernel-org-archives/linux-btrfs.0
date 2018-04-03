Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42877 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752471AbeDCGQ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 02:16:26 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: check: Skip data csum verification for
 metadata dump
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180403053947.5908-1-wqu@suse.com>
 <28d6599f-136a-a053-b4e9-6cb296a35d2a@suse.com>
 <9ab95bd6-afcc-fca3-be39-1051d42529bb@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <22010cab-f4fc-b2d6-bfbb-52b1dcb856d4@suse.com>
Date: Tue, 3 Apr 2018 09:16:24 +0300
MIME-Version: 1.0
In-Reply-To: <9ab95bd6-afcc-fca3-be39-1051d42529bb@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  3.04.2018 08:55, Qu Wenruo wrote:
> 
> 
> On 2018年04月03日 13:51, Nikolay Borisov wrote:
>>
>>
>> On  3.04.2018 08:39, Qu Wenruo wrote:
>>> For metadata dump (fs restored by btrfs-image), since no data is
>>> restored check sum verification will definitely report error.
>>>
>>> Add such check in check_csums() and prompt for user.
>>>
>>> Issue: #103
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>>
>>> ---
>>>  check/main.c | 13 ++++++++++++-
>>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/check/main.c b/check/main.c
>>> index 891a6d797756..15c94543946a 100644
>>> --- a/check/main.c
>>> +++ b/check/main.c
>>> @@ -5601,6 +5601,7 @@ static int check_csums(struct btrfs_root *root)
>>>  	int ret;
>>>  	u64 data_len;
>>>  	unsigned long leaf_offset;
>>> +	bool verify_csum = !!check_data_csum;
>>
>> nit: Why don't you convert check_data_csum to bool in this patch.
> 
> Next thing to do.
> 
>> My
>> recent testing in !! usage showed that it's generating quite a number of
>> additional instructions.
> 
> That's pretty interesting.
> 
> Would you please shared some more info about this?

So it seems I might have been mistaken. The latest experiment I did was
with the attached diff. So I did a bloat-o-meter comparison between
stock random.c against the diff applied and then modified the diff to
use uuid rather than !!uuid. And in my initial experiment I did see a
reduction in the size of the function. However, now that I tried
reproducing I couldn't. So just ignore my comment.

Bloat-o-meter shows in both cases:

nborisov@fisk:~/projects/kernel/source$ ./scripts/bloat-o-meter
random.original drivers/char/random.o
add/remove: 0/0 grow/shrink: 1/0 up/down: 49/0 (49)
Function                                     old     new   delta
proc_do_uuid                                 227     276     +49
Total: Before=30542, After=30591, chg +0.16%



  diff --git a/drivers/char/random.c b/drivers/char/random.c

index ec42c8bb9b0d..e05daf7f38f4 100644

--- a/drivers/char/random.c

+++ b/drivers/char/random.c

@@ -1960,6 +1960,10 @@ static int proc_do_uuid(struct ctl_table *table,
int write,
    unsigned char buf[64], tmp_uuid[16], *uuid;



    uuid = table->data;

+#ifdef CONFIG_UTS_NS

+   if (!!uuid && (uuid == (unsigned char *)sysctl_bootid))

+       uuid = current->nsproxy->uts_ns->sysctl_bootid;

+#endif

    if (!uuid) {

        uuid = tmp_uuid;

        generate_random_uuid(uuid);

diff --git a/include/linux/utsname.h b/include/linux/utsname.h

index c8060c2ecd04..f704aca3e95a 100644

--- a/include/linux/utsname.h

+++ b/include/linux/utsname.h

@@ -27,6 +27,7 @@ struct uts_namespace {

    struct user_namespace *user_ns;

    struct ucounts *ucounts;

    struct ns_common ns;

+   char sysctl_bootid[16];

 } __randomize_layout;

 extern struct uts_namespace init_uts_ns;



diff --git a/kernel/utsname.c b/kernel/utsname.c

index 913fe4336d2b..f1749cdcd341 100644

--- a/kernel/utsname.c

+++ b/kernel/utsname.c

@@ -34,8 +34,10 @@ static struct uts_namespace *create_uts_ns(void)

    struct uts_namespace *uts_ns;



    uts_ns = kmalloc(sizeof(struct uts_namespace), GFP_KERNEL);

-   if (uts_ns)

+   if (uts_ns) {

        kref_init(&uts_ns->kref);

+       memset(uts_ns->sysctl_bootid, 0, 16);

+   }

    return uts_ns;

 }
