Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:51710 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751382AbdFGRBe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Jun 2017 13:01:34 -0400
Reply-To: kreijack@inwind.it
Subject: Re: getting rid of "csum failed" on a hw raid
References: <5693147c-befc-da58-cb20-6af31e9aa9cb@xunil.at>
 <CAGqmi76XY0+sYZb3XaDs3rHKzZa=t2kzaGCE+uq_K4vz7PK5_A@mail.gmail.com>
 <b8195f2f-adf8-4eb6-2d48-ac6bb5f182fd@xunil.at>
 <CAGqmi77URH-XTW7fCB+NqzcSb-Y+LvwuvQep+CRJ6_ENgRtWRQ@mail.gmail.com>
 <20170607130902.q3stj6wj52duvmr2@angband.pl> <20170607184848.6218c92f@natsu>
 <20170607135219.blgoomc4mwt5ebvj@angband.pl>
 <ad923a84-bd2c-a8fd-8532-c7dc73d1870f@xunil.at>
 <CAJCQCtSGxC-UxkB7NuXuUvWYg-kC4sRdteiiVYQbPZpx9AUfsw@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>,
        "Stefan G. Weichinger" <lists@xunil.at>
Cc: Adam Borowski <kilobyte@angband.pl>, Roman Mamedov <rm@romanrm.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <dd64ae32-83c5-c254-a00f-e0f81d0b3eb9@inwind.it>
Date: Wed, 7 Jun 2017 19:01:21 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSGxC-UxkB7NuXuUvWYg-kC4sRdteiiVYQbPZpx9AUfsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-06-07 17:58, Chris Murphy wrote:
> I'm confused about a few items in this thread:
> 
> 1. On normal read, if there's a csum mismatch, there should be a path
> to file and EIO, because Btrfs won't propagate bad data up to user
> space. I'd expect if there's metadata corruption, there'd be no path
> to file, and no EIO. The original email does include an inode, but
> that's ambiguous since each fs tree has its own set of inodes, so we
> can't always easily infer a file from an inode.

Usually the number of fs-trees is a lot smaller than the number of files. So even if the fs-root is not displayed, it could be easily guessed. Anyway I understood that the file was found doing "cp -r / /dev/null" (which means try all the files until you find a problem)
> 
> 2. Why does ddrescue work around this problem on a mounted file
> system? It's just reading the file, through the file system, the exact
> same errors should have happened.

Which problem are you discussing ? Finding the path or getting the data ? Anyway ddrescue is not able to get the data with a wrong checksum. When the data is not good, it is skipped leaving an hole in the destination file.

> 
> 3. My take on this would have been to use btrfs restore and go after
> the file path if I absolutely needed a copy of this file (no backup),
> and then copied that back to the file system.


It might be useful to have a command to handle these situations: read all the good data, read even the wrong data logging the range were the checksum is incorrect. The fact that you have problem in few bytes, doesn't mean that all the 4k sector has to be discarded.

> 
> 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
