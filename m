From: Simon Farnsworth <simon@farnz.org.uk>
Subject: Re: [PATCH] Btrfs: add extent-same ioctl for dedup
Date: Wed, 05 Jan 2011 17:50:42 +0000
Message-ID: <ig2b1i$ph9$1@dough.gmane.org>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <1294245410-4739-2-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:

> This adds the ability for userspace to tell btrfs which extents match
> eachother. You pass in
> 
> -a logical offset
> -a length
> -a hash type (currently only sha256 is supported)
> -the hash
> -a list of file descriptors with their logical offset
> 
> and this ioctl will split up the extent on the target file and then link
> all of
> the files with the target files extent and free up their original extent. 
> The hash is to make sure nothing has changed between the userspace app
> running and we doing the actual linking, so we hash everything to make
> sure it's all still
> the same.  This doesn't work in a few key cases
> 
> 1) Any data transformation whatsoever.  This includes compression or any
> encryption that happens later on.  This is just to make sure we're not
> deduping things that don't turn out to be the same stuff on disk as it is
> uncompressed/decrypted.
> 
> 2) Across subvolumes.  This can be fixed later, but this is just to keep
> odd problems from happening, like oh say trying to dedup things that are
> snapshots
> of eachother already.  Nothing bad will happen, it's just needless work so
> just don't allow it for the time being.
> 
> 3) If the target file's data is split across extents.  We need one extent
> to point everybody at, so if the target file's data spans different
> extents we
> won't work.  In this case I return ERANGE so the userspace app can call
> defrag and then try again, but currently I don't do that, so that will
> have to be fixed at some point.
> 
> I think thats all of the special cases.  Thanks,
> 
I'm going to ask the stupid question: What happens if an attacker user can 
race against the dedupe process?

In particular, consider the following hypothetical scenario:

Attacker has discovered a hash collision for some important data that they 
can read but not write (e.g. /etc/passwd, /home/user/company-critical-
data.ods). They copy the important data from its original location to 
somewhere they can write to on the same filesystem.

Now for the evil bit; they wait, watching for the dedupe process to run. 
When it's had time to verify hash and memcmp the data, but before it calls 
the ioctl, Attacker swaps the copy of the data under their control for the 
bad one with the hash collision.

If I've understood the code correctly, if Attacker's version of the data is 
the source from the perspective of the ioctl, the kernel will hash the data, 
determine that the hash matches, not cross-check the entire extent with 
memcmp or equivalent, and will then splice Attacker's version of data into 
the original file. If the collision merely lets Attacker trash the original, 
that's bad enough; if it lets them put other interesting content in place, 
it's a really bad problem.

-- 
Here's hoping I simply missed something,

Simon Farnsworth

