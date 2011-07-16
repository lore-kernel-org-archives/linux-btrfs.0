From: aayush gupta <aayushgupta.84@gmail.com>
Subject: end_io worker thread with preempt count 1?
Date: Sat, 16 Jul 2011 19:18:24 -0400
Message-ID: <CAFBtnvQ-pzqOmi=opHsTGAT3_TM7TDmJaQxXpaksfMVQJU8Amw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have started looking into Btrfs data structures and trying to
understand its code flow.

The Btrfs worker thread relating to metadata end-io (btrfs-end-io-met)
seems to have preempt count set to 1 which means that it should be run
in atomic context. I found this while looking into the checksumming
code (csum_tree_block) called from btrfs_readpage_end_io_hook. Please
let me know if I am correct in my understanding and what is the reason
for having it non-preemptible?

Thanks,
Aayush
