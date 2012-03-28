From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: Fractal Tree Indexing over B-Trees?
Date: Wed, 28 Mar 2012 14:45:52 -0400
Message-ID: <4F735C60.7050708@suse.de>
References: <loom.20120328T160525-464@post.gmane.org> <20120328184204.GB1941@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Danny Piccirillo <danny.piccirillo@member.fsf.org>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120328184204.GB1941@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/28/2012 02:42 PM, Josef Bacik wrote:
> On Wed, Mar 28, 2012 at 02:25:39PM +0000, Danny Piccirillo wrote:
>> The case has been made on Phoronix for F-Trees: They makes use
>> hard drive speeds, not (relatively slow) access times; beat
>> SSD's; and scale perfectly across multiple cores with hundreds of
>> millions of entries.

> So no I don't think it's time for someone to get started on ftrfs.
> Thanks,

Thanks for doing the research to back up the answer I was going to
respond with based on intuition.

+1

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPc1xgAAoJEB57S2MheeWydJIP/R7jHiloaPLfwffuFS3gobmy
h0DqX8YezGMs70kLBYTXeu3EVuFtX8IFGJDGoVp3pkM9nS6F6iK9LbRWDC7IDAy7
t1taQoUqy0HMmmrkXfZ8KWmXWv424/Zq5aHfnegL/oq4OrUwnHtjzJBbsx4fvezW
mnPrNlOxaLWgXSyUs+1hDjvcgfmnRjpgURHfsfGNgX3gTUE4xNKCFXD4zs0bs5YO
NcpLa/66R5UwINPLOazHt9QpC2jHxPb0j93YZBipwtbtXPj1W+od/0rOgPvc9gaK
hzi7kRiegt50V2LVOJnofdaBC0AlCfRlcXRUNOil1vgFe6s8sft1KOdl8MShQ/+t
JUTjb1j7Z3efds42nnahvNj8wV4T6z6qLlhSQiOulYbVarBsfrWoM3EJY2ObzIlM
uOjCIPwHr/fzMJ9wVyLgK2ksssZmYAVgQ3YyS9G1CHIPe9xgW9Ld570mhhXRoLRj
HG5QZkfkmFzlde+S/gGgrdrvTWDT1zDsUhe+IGYu3jtPjXVs1udB+BN3c7rTWjf+
gQUOdcS/6XHoTXWpgZ7p5DUb8qF7Nv+ABBcEWeiaIEPH7uUZ22/XZEdf2euSCTp2
+TRZfoj9PZ17cszkllG4n+kc5H4gdKMYRyvNQo9mQ2TvogsmVOgIY+0Fys2ZdOkF
CaZ6ti9ZLkofawzImOV5
=UaEh
-----END PGP SIGNATURE-----
