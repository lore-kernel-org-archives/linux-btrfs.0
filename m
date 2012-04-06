From: David Sterba <dave@jikos.cz>
Subject: Re: kernel BUG at extent-tree.c:3162 (get_restripe_target)
Date: Fri, 6 Apr 2012 17:43:14 +0200
Message-ID: <20120406154314.GI14256@twin.jikos.cz>
References: <CAKcLGm8SgQchrk1fVg0FZ9uqr1v+cLzoWt1jk7vsJdZVfA72pA@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm8SgQchrk1fVg0FZ9uqr1v+cLzoWt1jk7vsJdZVfA72pA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 06, 2012 at 10:33:04AM -0500, Mitch Harder wrote:
> I'm consistently hitting the BUG_ON in the new get_restripe_target
> function that was added by "[PATCH 4/8] Btrfs: add
> get_restripe_target() helper" when trying to initially mount a btrfs
> partition.
> 
> Lines fs/btrfs/extent-tree.c:3161-3162:
> 
> 	BUG_ON(!mutex_is_locked(&fs_info->volume_mutex) &&
> 	       !spin_is_locked(&fs_info->balance_lock));

Is it a single CPU machine? See

http://www.spinics.net/lists/linux-btrfs/msg15884.html

david
