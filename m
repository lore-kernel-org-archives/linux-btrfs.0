From: Paul Millar <paul.millar@desy.de>
Subject: Re: A couple of questions
Date: Wed, 2 Jun 2010 15:40:24 +0200
Message-ID: <201006021540.25725.paul.millar@desy.de>
References: <201005271539.55644.paul.millar@desy.de> <201005312006.47321.paul.millar@desy.de> <yq1ljaykh1z.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <yq1ljaykh1z.fsf@sermon.lab.mkp.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 01 June 2010 15:39:52 Martin K. Petersen wrote:
> >>>>> "Paul" == Paul Millar <paul.millar@desy.de> writes:
> Paul> My concern is that, if the server-software doesn't push the
> Paul> client-provided checksum then the FS checksum (plus T-10 DIF/DIX)
> Paul> would not provide a rigorous assurance that the bytes are the
> Paul> same.  Without this assurance, corruption could still occur; for
> Paul> example, within the server's memory.
> 
> For DIX we allow integrity metadata conversion.  Once the data is
> received, the server generates appropriate IMD for the next layer.  Then
> the server verifies that the original IMD matches the data buffer.  That
> way there's no window of error.  But obviously the ideal case is where
> the same IMD can be passed throughout the stack without conversion.

I think we may be talking slightly at cross-purposes here: in my case, one of 
the end-points (for "end-to-end data integrity") is a remote computer, that is 
uploading a file with a corresponding checksum.

Please correct me if I'm wrong here, but T10 DIF/DIX refers only to data 
integrity protection from the OS's FS-level down to the block device: a 
userland application doesn't know that it is writing into a FS that is 
utilising DIX with a DIF-enabled storage system.

When a file is uploaded from a remote client to an application with the 
checksum, the app can verify this checksum internally.  However, there's then 
a (logical) gap between userland and FS where data integrity is no longer 
assured.  For example, corruption that occurs after the app has verified the 
checksum value would not be picked up, even with T10 DIX/DIF, since the FS 
would receive and store the already-corrupted data "in good faith".

In principle, one can add a btrfs-specific mechanism to continue this 
assurance from userland down to the FS.  Perhaps the simplest would be to 
allow userland applications to read the FS's internal checksum (app would read 
the FS internal checksum after writing and verify it is consistent), but I 
guess more sophisticated (interleaved IMD, T10-like) mechanisms are also 
possible.

Unfortunately, any such solution would be btrfs-specific, since (I believe) no 
one has standardised how to extend T10 into userspace.


> Not sure what you use for file service?  I believe NFSv4 allows for
> checksums to be passed along. I have not looked at them closely yet,
> though.

I believe NFS currently doesn't support checksums (as per v4.1).  Looking into 
more detail, Alok Aggarwal gave a talk at 2006 connectathon about this.  
Alok's slides have a nice diagram (slide 11) showing the kind of end-to-end 
integrity I'm after.  The issue is how to achieve the assurance between "NFS 
Server" and "Local FS" on the right.

For NFS, I believe there aren't any plans for introducing checksum support for 
v4.2.  Perhaps it'll appear with the later minor versions of the standard.

Cheers,

Paul.
