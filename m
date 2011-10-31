From: David Sterba <dave@jikos.cz>
Subject: Re: [patch] Move nodesize/leafsize/sectorsize to fs_info
Date: Mon, 31 Oct 2011 14:51:43 +0100
Message-ID: <20111031135143.GB19328@twin.jikos.cz>
References: <CAKyAS7s1Xm3L_1QwptAKs61e0bc4s4z7k8jWo4SiujQFMSss0g@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Peeters Simon <peeters.simon@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKyAS7s1Xm3L_1QwptAKs61e0bc4s4z7k8jWo4SiujQFMSss0g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Simon,

On Sun, Aug 07, 2011 at 11:54:31PM +0200, Peeters Simon wrote:
> moved nodesize, leafsize and sectorsize from btrfs_root to
> btrfs_fs_info as mentioned in [1] and updated everything accordingly.
> patch against the "for-linus" tree
> builds and loads, no further testing done.

Please add a "btrfs:" prefix to the subject line of the patch and add
your "Signed-off-by:" line, and also revise the changelog, so it
describes what the patch does and why, no need to reference the wiki
there (you can add such information after a '---' marker following the
changelog).

Please rebase your patch on top of Josef's for-chris branch, the sources
have evolved since your first posting (though the fixup is trivial, but
the process still needs your S-O-B line).


thanks,
david
