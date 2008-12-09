From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: Selective Compression/Encryption
Date: Tue, 9 Dec 2008 13:09:51 -0500
Message-ID: <20081209180951.GA6551@tux64-03>
References: <20081209145952.GA30494@tux64-03> <f058a9c30812090745v15b5f983u468b560ae791dc37@mail.gmail.com> <200812091722.21567.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Christian Hesse <mail@earthworm.de>, miguel.filipe@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200812091722.21567.mail@earthworm.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 09, 2008 at 05:22:18PM +0100, Christian Hesse wrote:
> On Tuesday 09 December 2008, Miguel Figueiredo Mascarenhas Sousa Filipe wrote:
> > Hi there,
> >
> > On Tue, Dec 9, 2008 at 2:59 PM, Lee Trager <lt73@cs.drexel.edu> wrote:
> > > Currently compression and I assume if encryption is implemented it is
> > > turned on or off during mount. There are however many times when a user
> > > may want to select which files/directories they want to compress or
> > > encrypt. This will also be helpful when implementing btrfs support in
> > > grub for example. We can say the disk can be compressed/encrypted except
> > > for /boot so compression/encryption doesn't have to be implemented in
> > > grub.
> 
> You could just use an additional partition for /boot that has compression an 
> encryption disabled...
>
Yes you could but many distributions are moving away from that such as
ubuntu. Also while this works well on desktop and server environments
where space is not an issue on embedded systems where free space is
measured in kb or mb it starts becomming a huge issue.
 
> > > I was thinking of adding this functionality to the userspace application
> > > btrfstune. The way I was thinking of doing this is when btrfstune +c is
> > > applied to a directory or file the directory(and all its contents) or
> > > file will always be compressed reguardless of how the filesystem is
> > > mounted. The opposite would happen when btrfstune -c is used.
> > >
> > > Would this be a reasonable thing to implement? Any suggestions before I
> > > start doing this?
> >
> > Things like compression or encription should be used at the "volume" level.
> 
> That was what I said some time ago when I asked why encryption support for 
> btrfs is planned. On a volume level you can use dm-crypt and the fs can 
> ignore that part completely.
> 
> The answer was that different users on a home partition could use their own 
> encryption key. That sounds like volume level is out of bet. ;)
> 
It does seem that doing it with volumes would limit user control and add
lots of complexity to such a simple task.

Miguel, what is your reason for suggesting this be done at the volume level?

> > So.. if a user wants a specific set of files or dirs ..they should
> > create a mount-point/volume like:
> >
> > private_vol
> > bigarchives_vol
> >
> > and set those volumes as compressed or encripted volumes
> >
> > Regarding usability, the best would be for the sub-volume creation
> > tool to optionally allow passing encription/compression arguments.
> >
> >
> > and then:
> >  should mount those volumes somewhere like: ~/Confidential or ~/Archives.
> >
> > Basically, do it at the directory level (which in btrfs is at the
> > sub-volume level).
> > File-level granularity is totally unmanageable in the long term.
> >
> > Kind regards,
> 
> -- 
> Regards,
> Chris

Lee
