Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41385 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751305AbdFFLXO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Jun 2017 07:23:14 -0400
Date: Tue, 6 Jun 2017 13:22:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v5 2/2] Btrfs: compression must free at least one sector
 size
Message-ID: <20170606112211.GA12135@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170529231805.4797-1-nefelim4ag@gmail.com>
 <20170529231805.4797-3-nefelim4ag@gmail.com>
 <20170605161003.GX12135@twin.jikos.cz>
 <CAGqmi76jA2YmchTrQkMUFPfbXEtDXMs9C3Ji7v7kN_vtffAP_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi76jA2YmchTrQkMUFPfbXEtDXMs9C3Ji7v7kN_vtffAP_Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 05, 2017 at 09:56:14PM +0300, Timofey Titovets wrote:
> 2017-06-05 19:10 GMT+03:00 David Sterba <dsterba@suse.cz>:
> > On Tue, May 30, 2017 at 02:18:05AM +0300, Timofey Titovets wrote:
> >> Btrfs already skip store of data where compression didn't
> >> free at least one byte. Let's make logic better and make check
> >> that compression free at least one sector size
> >> because in another case it useless to store this data compressed
> >>
> >> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> >> ---
> >>  fs/btrfs/inode.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >> index 17cbe930..2793007b 100644
> >> --- a/fs/btrfs/inode.c
> >> +++ b/fs/btrfs/inode.c
> >> @@ -609,9 +609,10 @@ static noinline void compress_file_range(struct inode *inode,
> >>               /*
> >>                * one last check to make sure the compression is really a
> >>                * win, compare the page count read with the blocks on disk
> >> +              * compression must free at least one sector size
> >>                */
> >>               total_in = ALIGN(total_in, PAGE_SIZE);
> >> -             if (total_compressed >= total_in) {
> >> +             if (total_compressed + blocksize > total_in) {
> >
> > We're doing aligned calculation here, shouldn't this be >= ?
> >
> > If total_compressed + blocksize == total_in, we have saved exactly one
> > blocksize.
> 
> We discussed that already in:
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg64350.html
> 
> IIRC: long in short:
> - input data size 8192
> - output data size 4096
> 
> This invertion logic, i.e. check if compression can be skipped, if
> comparasion are true -> skip compression.
> 
> In case of above check,
> old logic:
> total_compressed >= total_in
> 4096 >= 8192 -> will_compress=1
> With if blocksize added:
> 4096+4096 >= 8192 -> will_compress=0
> So this must be changed to:
> 4096+4096 > 8192 -> will_compress=1
> Because compression save one blocksize
> 
> Also will_compress not used after this code, so in theory this code
> can be refactored to be more obvious, like that:
>   total_in = ALIGN(total_in, PAGE_SIZE);
> -             if (total_compressed + blocksize > total_in) {
> -                          will_compress = 0;
> -             } else {
> +            if (total_compressed + blocksize <= total_in) {

Thanks. That way it's much more obvious to read, please update the patch
in that regard (ie. also removing will_compress).

>                           num_bytes = total_in;
>                            *num_added += 1;
