Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754113AbeFTRUA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:20:00 -0400
Subject: Re: [PATCH] btrfs: Fix a C compliance issue
To: dsterba@suse.cz, Bart Van Assche <Bart.VanAssche@wdc.com>,
        "nborisov@suse.com" <nborisov@suse.com>,
        "dsterba@suse.com" <dsterba@suse.com>, "clm@fb.com" <clm@fb.com>,
        "jbacik@fb.com" <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20180615223659.32420-1-bart.vanassche@wdc.com>
 <838e73e8-e9b8-6075-1d69-79bc65c15b0c@suse.com>
 <20180618092633.GH24375@twin.jikos.cz>
 <14645aca-930b-2d7d-a7d6-6893f7cfcbbd@suse.com>
 <c8f558835c1a767e24c00b7c3508a48a4d886cc4.camel@wdc.com>
 <20180620165556.GF24375@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <de233b2c-8487-5be6-c189-7fca5d453048@suse.com>
Date: Wed, 20 Jun 2018 13:19:55 -0400
MIME-Version: 1.0
In-Reply-To: <20180620165556.GF24375@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/20/18 12:55 PM, David Sterba wrote:
> On Wed, Jun 20, 2018 at 04:44:54PM +0000, Bart Van Assche wrote:
>> On Mon, 2018-06-18 at 12:31 +0300, Nikolay Borisov wrote:
>>> On 18.06.2018 12:26, David Sterba wrote:
>>>> On Sat, Jun 16, 2018 at 01:28:13PM +0300, Nikolay Borisov wrote:
>>>>> I'd rather not see more printk being added. Nothing prevents from having
>>>>> the fmt string being passed to pr_info.
>>>>
>>>> So you mean to do
>>>>
>>>> +	static const char fmt[] = "Btrfs loaded, crc32c=%s"
>>>> +	pr_info(fmt);
>>>
>>> Pretty much, something along the lines of
>>>
>>> pr_info(fmt, crc32c_impl).
>>>
>>> printk requires having the KERN_INFO in the format string, which I see
>>> no point in doing, correct me if I'm wrong?
>>
>> You should know that what you proposed doesn't compile because pr_info()
>> relies on string concatenation and hence requires that its first argument is
>> a string constant instead of a const char pointer. Anyway, I will rework this
>> patch such that it uses pr_info() instead of printk().
> 
> Right, the pr_info(fmt,...) does not compile. The closest version I got to is
> below. It does not look pretty, but I can't think of a better version right
> now.
> 
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2369,7 +2369,8 @@ static __cold void btrfs_interface_exit(void)
>  
>  static void __init btrfs_print_mod_info(void)
>  {
> -       static const char fmt[] = KERN_INFO "Btrfs loaded, crc32c=%s"
> +       static const char fmt1[] = "Btrfs loaded, crc32c=";
> +       static const char fmt2[] =
>  #ifdef CONFIG_BTRFS_DEBUG
>                         ", debug=on"
>  #endif
> @@ -2383,7 +2384,7 @@ static void __init btrfs_print_mod_info(void)
>                         ", ref-verify=on"
>  #endif
>                         "\n";
> -       printk(fmt, crc32c_impl());
> +       pr_info("%s%s%s", fmt1, crc32c_impl(), fmt2);
>  }
>  
>  static int __init init_btrfs_fs(void)

The shed should be yellow.

-Jeff

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 891cd2ed5dd4..57c9da0b459f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2375,21 +2375,20 @@ static __cold void btrfs_interface_exit(void)

 static void __init btrfs_print_mod_info(void)
 {
-	pr_info("Btrfs loaded, crc32c=%s"
+	pr_info("Btrfs loaded, crc32c=%s", crc32c_impl());
 #ifdef CONFIG_BTRFS_DEBUG
-			", debug=on"
+	pr_cont(", debug=on");
 #endif
 #ifdef CONFIG_BTRFS_ASSERT
-			", assert=on"
+	pr_cont(", assert=on");
 #endif
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
-			", integrity-checker=on"
+	pr_cont(", integrity-checker=on");
 #endif
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
-			", ref-verify=on"
+	pr_cont(", ref-verify=on")
 #endif
-			"\n",
-			crc32c_impl());
+	pr_cont("\n");
 }

 static int null_open(struct block_device *bdev, fmode_t mode)



-- 
Jeff Mahoney
SUSE Labs
