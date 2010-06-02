From: Paul Millar <paul.millar@desy.de>
Subject: Re: A couple of questions
Date: Wed, 2 Jun 2010 13:56:56 +0200
Message-ID: <201006021356.57504.paul.millar@desy.de>
References: <201005271539.55644.paul.millar@desy.de> <201005312006.47321.paul.millar@desy.de> <AANLkTim6wNus8lCN_xYt0yx0o6e5cqMtdsadz0HFqBta@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim6wNus8lCN_xYt0yx0o6e5cqMtdsadz0HFqBta@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mike,

On Monday 31 May 2010 22:33:23 Mike Fedyk wrote:
> On Mon, May 31, 2010 at 11:06 AM, Paul Millar <paul.millar@desy.de> wrote:
> > [...] My concern is that, if the server-software doesn't push the
> > client-provided checksum then the FS checksum (plus T-10 DIF/DIX) would
> > not provide a rigorous assurance that the bytes are the same [...]
> 
> Have you taken into account the boundaries of the data checksums?
> Your app may checksum per file or some logical partition in the file
> format. 

I'm thinking specifically of the case when the user creates a file, writes the 
file's contents and closes it;  for us, this is the only use-case when writing 
data.  In this scenario, the checksum would be of the file's complete data 
rather than any particular logical partition.

> Btrfs does the checksum per-extent so unless you keep track
> of where the extent boundaries are, that checksum will be useless to
> the userspace app. 

Sure, this is true with how things are currently.

However, I was hoping that it would be possible to add code within btrfs to 
obtain the checksum over the all the file's data.  Since btrfs knows the 
extend sizes and per-extend checksum values, I believe this is tractable and 
relatively easy.

> Also the app would be tied specifically to a storage technology.  No
> matter how great foo might be, not everyone's going to use it.

Sure, but I'm thinking of this behaviour (within the app) as being optional. 
The app would continue to be FS and storage-technology independent.

If the FS doesn't support internal consistency (e.g., ext3, xfs, ..) then the 
app would continue to do userland checksum verification on write:  it's better 
than nothing.

If the app is deployed on a node with btrfs then the app could try to "align" 
the user-supplied checksum with the value within the FS: either pushing the 
correct checksum value into the FS or reading the resulting FS-generated 
checksum value after writing and comparing it with the user-supplied value.

> Also are you going to get this info over nfs, cifs, lustre, gluster,
> ceph, foo, bar and baz?

This is certainly a valid concern. 

I can't speak for all these protocols and distributed filesystems: we don't 
support mounting our app with CIFS and the software doesn't participate with 
luster, gluster, ceph cluster filesystems.

However, here's information about the protocols we do support:

The majority of LAN transfers use a custom protocol.  The wire-protocol 
includes support for uploading a checksum value on close.

We also support the xrootd protocol, which allows clients to upload checksum 
values with the kXR_verifyw command.

We've also support for NFS v4.1.   NFS doesn't support uploading checksum (I 
believe, and it isn't part of current v4.2 work), but we may be able to work 
around this.

We also support WebDAV.  This currently has no support for checksum.

Almost all WAN transfers currently use GridFTP v2.  This includes the SCKS 
command, which allows the client to upload the correct checksum value.

In short, with current usage, the app will know the checksum value, as 
supplied by the remote client.

Cheers,

Paul.

