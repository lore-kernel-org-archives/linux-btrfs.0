From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: [PATCH v2 2/2] Cancel filesystem balance.
Date: Fri, 12 Nov 2010 10:26:38 +0100
Message-ID: <4CDD084E.5090908@gmail.com>
References: <cover.1289522188.git.hugo@carfax.org.uk> <9b18b334410714aba2867f96e949f19243536ddc.1289522188.git.hugo@carfax.org.uk> <4CDC9971.6080903@cn.fujitsu.com> <4CDCC258.1050402@csamuel.org> <20101112090755.GA16221@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Samuel <chris@csamuel.org>, Li Zefan <lizf@cn.fujitsu.com>,
	Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>
To: sander@humilis.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101112090755.GA16221@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 12.11.2010 10:07, Sander wrote:
> Chris Samuel wrote (ao):
>> On 12/11/10 12:33, Li Zefan wrote:
>>
>>> Is there any blocker that prevents us from canceling balance by
>>> just Ctrl+C ?
>>
>> Given that there's been at least 1 report of it taking 12 hours
>> to balance a non-trivial amount of data I suspect putting this
>> operation into the background by default and having the cancel
>> option might be a better plan.
>>
>> Thoughts ?
>
> My humble opinion: I very much like the way mdadm works, with the
> progress bar in /proc/mdstat if an array is rebuilding for
> example.
>
> Sander
Just my personal opinion: I would like the balance to happen in
background by default (with an option for foreground operation as
well) and another command/option to cancel the operation. Of course, a
progress bar (together with some estimate of the remaining time?) like
the one mdadm offers would be great.

Andreas Philipp
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJM3QhMAAoJEJIcBJ3+XkgioZoQAJ5bAD1xShKfda9oPK75x707
0AYu7C4sUSbu/3BINCv7XEv8MNBU++2FezRc/weSXjgmkhX4pXpMBhFZL6edlpot
VQ0y87rJ79HPe1NibiAmp4HOW95J2+R987mOJpIU10xU1TvpWAhpQextUKi27eg+
Z+XO/vm0oCv0+6YSqKnjpUPNd12r5zo7msanPnny5t57oFDXd6LCRjflt5FsP6mI
HKdM3R3EiBdlCyJsBpjDCZmJpUKvOFqoqn2OT/g7BHkE6XjuY0HqUysFLbNtWGIr
zhnx95W+cqgFY1YAvLwbrirtzX8MvO4R83c+klwQJPM9eL3+GkxyMrbnN3uQ4ie+
1wsgVCyyVT6QFLXnVeqo4ZvSNZh2/9S6waL1T0cFj1YAKBnDI3mCPo+S9CcIUuH4
KnOv3bqA3okAy0WUh3FuWNOc9fMX3tEPtE+b9JqDo1BmG0ZdnsGEdbJQxRe1xRFG
CwWsT1efV1tXEqrfsigxAlpMj9PY/uagwEYmhjQG1QU9/yGhXeZYfvE/cdYD5+Nj
chB2CpHISyQSLKAqwvLRF/tmkIjMRWrW2O3j3RGmkyEyrGl7eFKM0//1n1kmkGMc
SEAF3/fn61Wt/4YtA9r1py1Xe1deNhBGVuQQe2M1YMhITV0wSjIWPjmeL0eYu8n7
EsJdFOXoQIxIlkI7/lB+
=FQQ8
-----END PGP SIGNATURE-----

