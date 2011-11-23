From: Phillip Susi <psusi@cfl.rr.com>
Subject: [PATCH 0/3] Show Chunks by position
Date: Tue, 22 Nov 2011 20:12:43 -0500
Message-ID: <4ECC488B.7010406@cfl.rr.com>
References: <4EC67EAE.2090602@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC67EAE.2090602@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/18/2011 10:50 AM, Phillip Susi wrote:
> This is a nice little tool.  The one suggestion that I have is that
> it display the actual chunks and where they are located.  It seems
> that right now it uses the same ioctl that btrfs fi df uses, and that
> just gets the total combined size for all chunks of a given type.  It
> would be nice if the gui actually parsed the chunk tree and showed
> each individual chunk with lines showing how they are mapped to the
> physical disks.

I managed to cobble together the following patches to implement this.
The one thing that I still don't like is that the radio knob is in the
data replication and allocation box, instead of the volumes box.  My
python and tkinter skills are too lacking to figure out how to move it
down there.


Phillip Susi (3):
  Changed volume_df() to return all chunks with their offsets
  Update UsageDisplay to be capable of displaying all chunks by
    position
  Add radio knob to show space by position or combined

 btrfsgui/gui/usagedisplay.py |   98
++++++++++++++++++++++++++++--------------
 btrfsgui/hlp/size.py         |   18 +++----
 2 files changed, 73 insertions(+), 43 deletions(-)

- -- 
1.7.5.4

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7MSIoACgkQJ4UciIs+XuLyjQCeI4m7+u75R863B2RY3hkFELbP
iJ8AoJwzVdiYZqgE1tXvHEOHz+gciDgj
=dfd1
-----END PGP SIGNATURE-----
