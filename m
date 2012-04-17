From: Marc MERLIN <marc@merlins.org>
Subject: Re: Creating backup snapshots (8 per filesystem) causes No space
 left on device?
Date: Tue, 17 Apr 2012 07:16:48 -0700
Message-ID: <20120417141648.GA6685@merlins.org>
References: <20120415150740.GA10248@merlins.org>
 <CAE5mzvgKKj=7Xiv8uev5CKrGojjhep5mX9Si=kLd+=shQDyEnQ@mail.gmail.com>
 <20120415150740.GA10248@merlins.org>
 <CAGy7Utjp79TVTnHyCqr1+iEr7c3g0_3X74CKLe91817DoK48DA@mail.gmail.com>
 <20120415162727.GD10248@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Bart Noordervliet <bart@noordervliet.net>,
	cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120415162727.GD10248@merlins.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 15, 2012 at 09:27:27AM -0700, Marc MERLIN wrote:
> I'll watch for 3.3.x updates (I see nothing in 3.3.2 yet), thanks.
> 
> Or is it just a matter of reverting this patch?
> https://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=5500cdbe14d7435e04f66ff3cfb8ecd8b8e44ebf
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index dc083f5..079e5a1 100644 (file)
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4108,7 +4108,7 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
>         num_bytes += div64_u64(data_used + meta_used, 50);
>  
>         if (num_bytes * 3 > meta_used)
> -               num_bytes = div64_u64(meta_used, 3);
> +               num_bytes = div64_u64(meta_used, 3) * 2;
>  
>         return ALIGN(num_bytes, fs_info->extent_root->leafsize << 10);
>  }

After I knew what to look for, I searched the archives some more and
they only seemed to point to this patch.
I have reverted it, but I'm still seeing the same problem on my laptop.

It sounds like I'll have to downgrade back to 3.2.x unless there is
some other patch to revert that I missed.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
