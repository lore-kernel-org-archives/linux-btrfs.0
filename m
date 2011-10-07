From: Dave <dave@thekilempire.com>
Subject: Re: Honest timeline for btrfsck
Date: Fri, 7 Oct 2011 11:22:29 -0400
Message-ID: <20111007152229.GA2787@hendrix.borisch.local>
References: <20110901203442.GA17928@carfax.org.uk>
 <201109101209.40759.Martin@lichtvoll.de>
 <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
 <20111005061628.GA3702@shiny.elevennetworks.com>
 <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com>
 <20111005145843.GA4770@shiny.elevennetworks.com>
 <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com>
 <m239f550cp.fsf@firstfloor.org>
 <CAD6zcDxvXTZPOO-bXRfuMVWqOGbz8QdfHk=p0LT6Dequb9pmAg@mail.gmail.com>
 <4E8F119C.70006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Cc: Francesco Riosa <vivo75@gmail.com>,
	Jeff Putney <jeffrey.putney@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E8F119C.70006@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On Fri, Oct 07, 2011 at 10:50:04AM -0400, Josef Bacik wrote:
> If you still need that data, clone this repo
> 
> git://github.com/josefbacik/btrfs-progs.git
> 
> run make, and then run
> 
> ./restore /dev/whatever /some/dir
> 
> and it will try and suck all of your data off the disk and dump it in
> that directory.  If you have snapshots it will skip them by default, so
> if you have snapshots that have useful data in them you'll want to use
> the -s option.  If you run into random errors that you think are
> recoverable, or if you don't care about the file that's being recovered,
> you can run with -i which will ignore errors and keep trying to recover
> your files.  Thanks,

I'm actually MUCH more comfortable with this solution.  Rather than having an
untested fsck making changes to the filesystem, a way to get data off a broken
btrfs volume would be sufficient for the time being.  I've had three cases in
the past two months where I've had to resort to hacking the kernel to get at
data on broken btrfs volumes.  Since no one is using btrfs in production,
recovering a volume quickly is not a concern.  For people who haven't backed up
since yesterday, but want to recover the 8 hours of work they did today, the
above solution is great.

(Mind you I've never actually tried the solution above)

- -- 
- -=[dave]=-

Entropy isn't what it used to be.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iF4EAREIAAYFAk6PGTUACgkQXM0u5ajNnChDJQD7BqDiiMk0KZL0HBaveFIolYc4
VFaQpiyZoPkkmL9i/e4A/2c+t+w/xrmOMu5+245DoRhKMOsQ0bNPps9GSiDNJwW5
=0lnT
-----END PGP SIGNATURE-----
