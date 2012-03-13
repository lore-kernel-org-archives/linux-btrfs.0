From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: NOCOW + compress-force = bug
Date: Tue, 13 Mar 2012 14:11:05 -0400
Message-ID: <4F5F8DB9.40208@suse.de>
References: <4F38B8F0.5020506@yahoo.com> <4F38BE53.4080204@parallels.com> <20120213141040.GG15350@twin.jikos.cz> <20120216195515.643f4aa7@natsu> <20120216175815.GM21896@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Roman Mamedov <rm@romanrm.ru>, dave@jikos.cz,
	dima <dolenin@parallels.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120216175815.GM21896@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/16/2012 12:58 PM, Chris Mason wrote:
> On Thu, Feb 16, 2012 at 07:55:15PM +0600, Roman Mamedov wrote:
>> Hello,
>> 
>> Please be aware that there seems to be a possible problem with
>> using NOCOW flag on files situated on a filesystem mounted with
>> compress-force(=lzo, in my case).
>> 
>> Since experimenting with NOCOW, I started regularly hitting this
>> BUG at extent-tree.c:5813
>> 
>> 5813                 BUG_ON(!(flags &
>> BTRFS_BLOCK_FLAG_FULL_BACKREF));
>> 
>> I was unable to make netconsole work over a bridged interface, so
>> can only post screenshots of this OOPS: 
>> http://romanrm.ru/pics/2012/2012-02-16-btrfs-bug-1.jpg 
>> http://romanrm.ru/pics/2012/2012-02-16-btrfs-bug-2.jpg
>> 
>> This happened four times already, and always on snapshot creation
>> (but not every case). I have hourly snapshots in crontab, and
>> only one case out of about ten fails with this problem. Did not
>> try to deliberately reproduce it yet by manually making snapshots
>> very often, etc.
> 
> Interesting, NOCOW and compression don't really mix.  We always cow
> for compression.  I'll try to reproduce it.

I hit this one today without nocow or compression. The only thing
non-default was that I mounted with -ossd. The backing store was a 1GB
non-sparse loopback file on tmpfs.

I had kdump enabled and with 16GB, I wasn't waiting around for the
dump to complete. If it happens again, I'll have a full stack trace.
My test case was filling the disk while making snapshots.

- -Jeff


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPX424AAoJEB57S2MheeWybq0P/1xv09dKpBfuvK/2vpyriebN
3RsPtHVZgAL9y9XeLVw0KPlRKTGM+PIyc+AEloIiYQgULifA625nPa6+DXlNqzCp
0jKVleAE5RLCOtBDC91GX8JO/55fszjTQHSXAHjSRr4vr/4bZEf4tLBTwbW7Nfax
YAUPQ6cu+FQlCDWppXMLswKmLsmnewTnKrZp0YQTOTVGY3dajsvGTR3vR0VyxMwY
FZ13hvGOfP+UXsZC1qijxA3g8CrWwu/dhiU/dnCYwhcCF+0ONiHHHhB3krDAkNP8
yVAZgoSGJsIUdDiqeKXaSm8RDT6vGQwnJicFQSkUqGiHXyi+/fXVUULNSbgj39EC
R2jHLlXtMMaRyoqiM/wOfZUOr5MGQhk0duXB1NjNGAaffAsjvBY0c8y4yvGJVhtR
E2EknQLHr2jBWF8KCpLe0YYLPjcB3Gp3SPUhyGZbg4ATUAv2amMcw13deI8I17gI
v9dJSCWyi+r5c0d26rgtsS9SpfM8qHz5A/EvqVtn99DgS+O49o4+3F8M+2WioDjM
mHndWGXqg4fBIwrpxvo5RtBmQ8OYgZzxZXoZU3XP/eRS4c6z8OJ9U92/pUFP64Id
6tpqU1E9XxEijTWwcIyvkSzu6bjOLQucePBPCKkWLtTy9XrbNMTmvcGozKNCTVKK
km1EWb9RM2m8JPrEc+JA
=ywbL
-----END PGP SIGNATURE-----
