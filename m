From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 65/99] btrfs: ->submit_bio_hook error push-up
Date: Thu, 24 Nov 2011 21:17:45 -0500
Message-ID: <4ECEFAC9.1090901@suse.com>
References: <20111124003533.395674389@suse.com> <20111124004227.342118564@suse.com> <20111125004604.GI12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111125004604.GI12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/24/2011 07:46 PM, David Sterba wrote:
> On Wed, Nov 23, 2011 at 07:36:38PM -0500, Jeff Mahoney wrote:
>> --- a/fs/btrfs/extent_io.c +++ b/fs/btrfs/extent_io.c @@ -2752,10
>> +2759,12 @@ retry: static void flush_epd_write_bio(struct
>> extent_page_data *epd) { if (epd->bio) { +		int ret; if
>> (epd->sync_io) -			submit_one_bio(WRITE_SYNC, epd->bio, 0, 0); +
>> ret = submit_one_bio(WRITE_SYNC, epd->bio, 0, 0); else -
>> submit_one_bio(WRITE, epd->bio, 0, 0); +			ret =
>> submit_one_bio(WRITE, epd->bio, 0, 0); +		BUG_ON(ret < 0);
> 
> this if/else could be transfomed in the same way as in
> 
> "63/99 btrfs: Simplify btrfs_submit_bio_hook"
> 
> int rw = WRITE;
> 
> if (epd->sync_io) rw = WRITE_SYNC;
> 
> ret = submit_one_bio(rw, ...);
> 

Yep. Thanks.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOzvrJAAoJEB57S2MheeWykzkP/R1hl05O57yxOTQXtYuJhvUF
RtL6RDD9nw/9QMWFHUXKFvaWtkuygi5BlcLKdXK0Zmsyk+hd7tzv8YfD1uLS2XS0
gioapvFNEmR6aRh1mMk6fJ429LiFgUrGGrCYQ28VTAgbe/RvMGedLAD6oqps5OJj
dsCkyUCBxl7ta6cFRlR37gj+rzKwDTEjRz3E2gx8oBjJWA/zXIoInBA+gEC1P3qn
YfmWyt31JwyOD3Oa2NQoCZGS7+MzotSe0RvAHbt5jc/DUDgJe+avv8Q5o4Bd2A7N
DAlAty/G8k9rUtEUOp53BclZdq2pDQ5hV/EEDMp743+Y5BoKTmpmXV1p4k7oVhvu
yOLTdYFtAo45c1pEeEzHm2GiowbdOemkmW3ySoFV8afRIVqkdgOfKMoUg6/c4B+o
StaAtihxBwSjZbmWSOtlwr8vHkqDK332nh5I6WF9OBcgEI4ZuH6GnmP2NEC5G9aj
03MFyyJuq53FBmM1CRHE94zc299ZwRxOxIkcSffR9Fm8ANXHlrELfXbVbkmWQf3e
bKs2skbAQmqbZE7yPbEHuN5vTElgP+MC56FBuVvJ+Lz4NO7HVV4KdfJKiM7J2QzA
qRsITdnnesKCfpkQTz4ShHZh+O3Y5ZgeP/wBNa9pK2+SZxA0HL3t8RaC/q/yjpYm
PBOaqH8nwVot+RBwI/Pv
=/8rB
-----END PGP SIGNATURE-----
