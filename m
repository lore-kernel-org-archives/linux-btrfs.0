From: Stephane Chazelas <stephane.chazelas@gmail.com>
Subject: Re: cloning single-device btrfs file system onto multi-device one
Date: Wed, 30 Mar 2011 12:58:57 +0100
Message-ID: <chaz20110330115857.GA1577@seebyte.com>
References: <chaz20110321162450.GB918@seebyte.com> <AANLkTinUW70Jje41YW6u2EJGiHZ3txK4W3MFRxJmMSsz@mail.gmail.com> <chaz20110328132403.GB18131@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110328132403.GB18131@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-03-28 14:24:03 +0100, Stephane Chazelas:
> 2011-03-23 12:13:45 +0700, Fajar A. Nugraha:
> > On Mon, Mar 21, 2011 at 11:24 PM, Stephane Chazelas
> > <stephane.chazelas@gmail.com> wrote:
> > > AFAICT, compression is enabled at mount time and would
> > > only apply to newly created files. Is there a way to compress
> > > files already in a btrfs filesystem?
> > 
> > You need to select the files manually (not possible to select a
> > directory), but yes, it's possible using "btrfs filesystem defragment
> > -c"
> [...]
> 
> Thanks. However I find that for files that have snapshots, it
> ends up increasing disk usage instead of reducing it (size of
> the file + size of the compressed file, instead of size of the
> file).
> 
> If I do the btrfs fi de on both the volume and its snapshot, I
> end up with some benefit only if the compression ratio is over
> 2 (and with more snapshots, there's little chance of getting any
> benefit at all). Also, with dozens of snapshots on a 4TB volume,
> it's likely to take weeks to do.
> 
> Is there a way around that?
[...]

OK, sorry. I can see now that it's a FAQ. So the answer to my
question would be "no"...

-- 
Stephane
