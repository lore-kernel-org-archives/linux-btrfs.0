From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [BUG - btrfs] kernel oops in extent_range_uptodate
Date: Fri, 20 Jan 2012 14:54:41 -0600
Message-ID: <CAKcLGm9ppCT94y2ijuEEQjH+tP8wPK1E+U6x6RHH2CjtoHmJMg@mail.gmail.com>
References: <4F182BED.3090009@gmail.com>
	<CAKcLGm9kVOw6D8kPECfhfohH4pAT=09qws7-jRsh1TZJTyh1_A@mail.gmail.com>
	<4F199AF9.4030909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Vincent Vanackere <vincent.vanackere@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F199AF9.4030909@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 20, 2012 at 10:48 AM, Vincent Vanackere
<vincent.vanackere@gmail.com> wrote:
> On 01/19/2012 05:24 PM, Mitch Harder wrote:
>>
>> On Thu, Jan 19, 2012 at 8:42 AM, Vincent Vanackere
>> <vincent.vanackere@gmail.com> =A0wrote:
>>>
>>> Hi,
>>>
>>> With the most current git kernel
>>> (90a4c0f51e8e44111a926be6f4c87af3938a79c3)
>>> I'm still getting the same reproducible kernel panic when trying to=
 read
>>> a
>>> particular file stored on a btrfs filesystem (as seen in the log th=
ere
>>> are
>>> indeed disk media errors on this disk).
>>> I'd like the "software" part of this to be fixed - btrfs should
>>> definitely
>>> not oops even in case of media error - before sending the disk to R=
MA. Is
>>> there anything I can do to make progress on this ?
>>>
>> Is this kernel compiled with "Compile the kernel with debug info" (i=
n
>> the "Kernel hacking =A0--->" configuration section)?
>>
>> It would be nice to have the specific line of code passing the NULL
>> pointer.
>
>
> The kernel was compiled with debug information but modern linux distr=
ibution
> make it really hard to keep your debug information it seems :-(

I see where the find_get_page(...) function called in
extent_range_uptodate has the potential to return a NULL value.

Could you try the following patch, and if it solves your oops and
shows the included warning in your dmesg log, I'll simplify the patch
to drop the printk and submit it to the list.

I only included the printk since your current error log is ambiguous
regarding the specific point where we're getting the NULL pointer
dereference, but I'll pull it out if it works.

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9d09a4f..35c3a2a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3909,6 +3909,13 @@ int extent_range_uptodate(struct extent_io_tree =
*tree,
 	while (start <=3D end) {
 		index =3D start >> PAGE_CACHE_SHIFT;
 		page =3D find_get_page(tree->mapping, index);
+		if (unlikely(!page)) {
+			if (printk_ratelimit())
+ 				printk(KERN_WARNING
+ 				       "btrfs: NULL page in "
+ 				       "extent_range_uptodate()\n");
+			return 1;
+		}
 		uptodate =3D PageUptodate(page);
 		page_cache_release(page);
 		if (!uptodate) {
