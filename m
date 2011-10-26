From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 07/66] btrfs: clear_extent_bit error push-up
Date: Wed, 26 Oct 2011 12:13:46 -0400
Message-ID: <4EA831BA.4060103@suse.de>
References: <20111025010236.322699279@suse.com> <20111025010851.368992601@suse.com> <20111026151024.GB5914@twin.jikos.cz> <4EA824D2.6070801@suse.com> <20111026160919.GC5914@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Jeff Mahoney <jeffm@suse.com>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111026160919.GC5914@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/26/2011 12:09 PM, David Sterba wrote:
> On Wed, Oct 26, 2011 at 11:18:42AM -0400, Jeff Mahoney wrote:
>>>> extent_io_tree *tree, u64 start, u64 end, -		       gfp_t
>>>> mask); +		       gfp_t mask) __must_check;
>>> ^^^^^^^^^^^^ shouldn't this be placed at the beginning of the 
>>> prototype?
>> 
>> I don't see why that would need to be the case. It needs to be at
>> the beginning of the prototype if it's the actual function
>> definition but not when it's a prototype.
> 
> I'm not aware of a general recommendation, but the __must_check is 
> related to return value and makes sense to place it there. There is
> no other instance of __must_check placed at the end of 
> declaratin/definition so I'm applying the "be consistent with 
> surrounding code" rule.

Putting it at the beginning means indenting the entire prototype,
which I'm not a fan of.

- -Jeff


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOqDG6AAoJEB57S2MheeWyv8MP/31fGc7lYFEvmJU9OgJ0cFiU
Bz5Tic3cvO/OXyvmzOvDrO3Gre6AeDB+NXkU2VkkMBOwocat9kTTcX3bzZ3pSVJr
GtGAqM0x8jF4h2WGIYzuqW+oyM/Bah4a+39tPycrz21piboygJax18rEqU0+dl1x
kyTzWbk4AwZJQrL205/BcXQqC+/08jluExhsUz8uTK7VDO5PO5ml11WyGY2uG4OD
mLXylADCUdnd7v7azcjQ/Oa/BB5lMJ+1LIu5YsuVDHbWfDfM0PQRKNbQiwN9jqww
notpLQmJuIVgU1PtV82bHnn/eRD1pJBWuTFkzWI1eg+mWgB8o03aSOTXQnoN5SR0
rdLcGnUmvZH+lwjskSbaPsiHqReW+6Pf+QhCEplNMGUFwlw+M9U2BhaCviEWMZC9
xYMFrqyvWFaBsz6FCvg/HjvaqSrOgT85yeNNhWTXtNH1J0SuEYA8USjOPoa9+TMD
jDlgEogFtkmhaZQd+qPSAdna0jCxB8e/zB5/XfBAwxtfVcWtB362wlMHE/a0M59a
tGt9DydF9UN6pQ7Kznx59rHS4IYND5MmBK4R9eqi5OPIFD3f4EMLU0qDemAUnmcV
2Ng9zIT6ka/RnzkecT8qg84Hg6qotQ2NL91zJ5ys8xAdUIq0gq8uhTmGD6qHVVeu
pRATEdBa3477yt+ex0Wd
=53Ir
-----END PGP SIGNATURE-----
