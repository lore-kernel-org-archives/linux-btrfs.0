From: Oystein Viggen <oysteivi@tihlde.org>
Subject: Re: [PATCH] Add supported kernel version check to mkfs.btrfs
Date: Thu, 23 Jul 2009 19:50:48 +0200
Message-ID: <038wif2sqv.fsf@msgid.viggen.net>
References: <20090723023411.23E8A8C03F@csamuel.org>
	<D102393B-AFF2-4771-822E-71D3762A1B45@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

* [Roy Sigurd Karlsbakk]=20

> On 23. juli. 2009, at 04.09, Chris Samuel wrote:
>
>> +	if ( kern_major > min_major )
>> +		return( 0 );
>> +	if ( kern_major < min_major )
>> +		return( -1 );
>> +	if ( kern_medium > min_medium )
>> +		return( 0 );
>> +	if ( kern_medium < min_medium )
>> +		return( -1 );
>> +	if ( kern_minor < min_minor )
>> +		return( -1 );
>> +
>> +	return( 0 );
>
>
> Why not simply this?
>
> if (kern_major < min_major || kern_medium < min_medium || kern_minor =
< =20
> min_minor)
>          return -1;
>
> return 0;

Doesn't look equivalent.  I think your shorter code would return -1 for
any kernel version a.b.c where any of a, b, or c is less than the
minimum.  Say, 2.8.10 (minor) or 3.0.40 (medium).

Either way, I guess the RHEL developers could tell people a thing or tw=
o
about the cleverness of assuming a kernel version equals a specific set
of features and/or bugs.  WIBNI the btrfs kernel driver could export
some kind of "btrfs_version" property that btrfs-tools could check
instead?

Then again, the need for shenanigans like this should pass quickly as
the file system matures.

=D8ystein
--=20
"Windows is too dangerous to be left to Windows admins."
                 -- James Riden in the monastery

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
