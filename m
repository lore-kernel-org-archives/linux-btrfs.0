Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:32999 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdEASRA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 May 2017 14:17:00 -0400
Received: by mail-vk0-f65.google.com with SMTP id m78so3433731vkf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 01 May 2017 11:16:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170501130941.hw7fuaovdnuvaxbc@mailbox.org>
References: <20170429215405.1123-2-christian.brauner@ubuntu.com> <20170501130941.hw7fuaovdnuvaxbc@mailbox.org>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Mon, 1 May 2017 23:46:18 +0530
Message-ID: <CAKuJGC_t-G_PDgSgBgbcMOEQgP8e0hXa0wkxg3iKGt25UVY5Dg@mail.gmail.com>
Subject: Re: [PATCH 1/1] btrfs-progs: send: fail on first -ENODATA only
To: Christian Brauner <christian.brauner@canonical.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>,
        Nazar Mokrynskyi <nazar@mokrynskyi.com>, dsterba@suse.cz,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Christian, thanks for fixing it quickly :) I don't have permission
to change the bug state to fixed, if you or Nazar have those rights, i
think this bug can be closed.
----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org


On Mon, May 1, 2017 at 6:39 PM, Christian Brauner
<christian.brauner@canonical.com> wrote:
> Hi,
>
> The original bug-reporter verified that my patch fixes the bug. See
>
> https://bugzilla.kernel.org/show_bug.cgi?id=195597
>
> Christian
>
> On Sat, Apr 29, 2017 at 11:54:05PM +0200, Christian Brauner wrote:
>> Returning -ENODATA is only considered invalid on the first run of the loop.
>>
>> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
>> ---
>>  cmds-receive.c | 20 ++++++++++++++------
>>  1 file changed, 14 insertions(+), 6 deletions(-)
>>
>> diff --git a/cmds-receive.c b/cmds-receive.c
>> index b59f00e4..72e9c8f3 100644
>> --- a/cmds-receive.c
>> +++ b/cmds-receive.c
>> @@ -1091,6 +1091,7 @@ static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
>>       char *dest_dir_full_path;
>>       char root_subvol_path[PATH_MAX];
>>       int end = 0;
>> +     int iterations = 0;
>>
>>       dest_dir_full_path = realpath(tomnt, NULL);
>>       if (!dest_dir_full_path) {
>> @@ -1198,13 +1199,18 @@ static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
>>                                                        rctx,
>>                                                        rctx->honor_end_cmd,
>>                                                        max_errors);
>> -             if (ret < 0 && ret == -ENODATA) {
>> +             if (ret < 0) {
>> +                     if (ret != -ENODATA)
>> +                             goto out;
>> +
>>                       /* Empty stream is invalid */
>> -                     error("empty stream is not considered valid");
>> -                     ret = -EINVAL;
>> -                     goto out;
>> -             } else if (ret < 0) {
>> -                     goto out;
>> +                     if (iterations == 0) {
>> +                             error("empty stream is not considered valid");
>> +                             ret = -EINVAL;
>> +                             goto out;
>> +                     }
>> +
>> +                     ret = 1;
>>               }
>>               if (ret > 0)
>>                       end = 1;
>> @@ -1213,6 +1219,8 @@ static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
>>               ret = finish_subvol(rctx);
>>               if (ret < 0)
>>                       goto out;
>> +
>> +             iterations++;
>>       }
>>       ret = 0;
>>
>> --
>> 2.11.0
>>
