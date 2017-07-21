Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:33401 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753502AbdGUVAg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 17:00:36 -0400
Date: Fri, 21 Jul 2017 23:00:27 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Roman Mamedov <rm@romanrm.net>
Cc: Anand Jain <anand.jain@oracle.com>, dsterba@suse.cz,
        Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: add skeleton code for compression heuristic
Message-ID: <20170721210027.3qoexc63zcbbnqxl@angband.pl>
References: <20170717135258.15865-1-nefelim4ag@gmail.com>
 <20170717183035.GR2866@twin.jikos.cz>
 <f85d6fa7-4d1e-bfb8-7e64-ef02c468e42d@oracle.com>
 <20170721233749.5175d611@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170721233749.5175d611@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 21, 2017 at 11:37:49PM +0500, Roman Mamedov wrote:
> On Fri, 21 Jul 2017 13:00:56 +0800
> Anand Jain <anand.jain@oracle.com> wrote:
> > On 07/18/2017 02:30 AM, David Sterba wrote:
> > > This must stay 'return 1', if force-compress is on, so the change is
> > > reverted.
> > 
> >   Initially I thought 'return 1' is correct, but looking in depth,
> >   it is not correct as below..
> > 
> >   The biggest beneficiary of the estimating the compression ratio
> >   in advance (heuristic) is when customers are using the
> >   -o compress-force. But 'return 1' here is making them not to
> >   use heuristic. So definitely something is wrong.
> 
> man mount says for btrfs:
> 
>     If compress-force is specified, all files will be compressed,  whether
>     or  not they compress well.
> 
> So compress-force by definition should always compress all files no matter
> what, and not use any heuristic. In fact it has no right to, as user forced
> compression to always on. Returning 1 up there does seem right to me.

Technically, for every compression algorithm other than identity (and its
bijections), some data will expand by at least one bit (thus byte, thus
page), therefore we need to be able to store with no compression even when
forced.  On the other hand, it sounds reasonable to take force to mean
"compression will always be attempted" -- ie, we forbid early return when
a small sample seems uncompressible.

> >   -o compress is about the whether each of the compression-granular bytes
> >   (BTRFS_MAX_UNCOMPRESSED) of the inode should be tried to compress OR
> >   just give up for the whole inode by looking at the compression ratio
> >   of the current compression-granular.
> >   This approach can be overridden by -o compress-force. So in
> >   -o compress-force there will be a lot more efforts in _trying_
> >   to compression than in -o compress. We must use heuristic for
> >   -o compress-force.
> 
> Semantic and the user expectation of compress-force dictates to always
> compress without giving up, even if it turns out to be slower and not providing
> much benefit.

Another question is, how would "compress-force" differ from "compress"
otherwise?  Always attempting the compression is its whole purpose!


Meow.
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
