From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: Inefficient storing of ISO images with compress=lzo
Date: Tue, 20 Sep 2011 01:06:17 +0200
Message-ID: <1316473579.31049.2.camel@picard>
References: <1316388769.2499.4.camel@picard>
	 <4E76AEB9.4080109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E76AEB9.4080109@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2011-09-19 at 10:53 +0800, Li Zefan wrote:
> Maciej Marcin Piechotka wrote:
> > I've noticed that:
> > 
> >  - with x86-64 Fedora 15 DVD install images:
> >    - du -sh <ROOT VOLUME> was 36 GB
> >    - btrfs df | grep -i data have shown over 40 GB used
> >  - without
> >    - du -sh <ROOT VOLUME> is 34 GB
> >    - btrfs df | grep -i data have shown less then 34 GB used
> > 
> > It seems that iso files are considered compressable while they may not be (and penalty is severe - 3x).
> > 
> 
> With compress option specified, btrfs will try to compress the file, at most
> 128K at one time, and if the compressed result is not smaller, the file will
> be marked as uncompressable.
> 
> I just tried with Fedora-14-i386-DVD.iso, and the first 896K is compressed,
> with a compress ratio about 71.7%, and the remaining data is not compressed.
> 
> --
> Li Zefan

Just a question from person who don't know how btrfs operates - what if
the beginning of file is well compressable and the rest is not?

In any case the compression was my uneducated guess where is missing
4GB.

Regards

