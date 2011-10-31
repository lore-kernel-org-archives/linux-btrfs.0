From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 07/66] btrfs: clear_extent_bit error push-up
Date: Mon, 31 Oct 2011 09:34:49 -0400
Message-ID: <4EAEA3F9.2010806@suse.com>
References: <20111025010236.322699279@suse.com> <20111025010851.368992601@suse.com> <20111026151024.GB5914@twin.jikos.cz> <4EA824D2.6070801@suse.com> <20111026160919.GC5914@twin.jikos.cz> <4EA831BA.4060103@suse.de> <20111031123041.GA26393@zambezi.lan> <20111031130050.GC4468@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Jeff Mahoney <jeffm@suse.de>, David Sterba <dsterba@suse.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111031130050.GC4468@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/31/2011 09:00 AM, Chris Mason wrote:
> On Mon, Oct 31, 2011 at 02:30:42PM +0200, Ilya Dryomov wrote:
>> On Wed, Oct 26, 2011 at 12:13:46PM -0400, Jeff Mahoney wrote:
>>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>>> 
>>> On 10/26/2011 12:09 PM, David Sterba wrote:
>>>> On Wed, Oct 26, 2011 at 11:18:42AM -0400, Jeff Mahoney
>>>> wrote:
>>>>>>> extent_io_tree *tree, u64 start, u64 end, -
>>>>>>> gfp_t mask); +		       gfp_t mask) __must_check;
>>>>>> ^^^^^^^^^^^^ shouldn't this be placed at the beginning of
>>>>>> the prototype?
>>>>> 
>>>>> I don't see why that would need to be the case. It needs to
>>>>> be at the beginning of the prototype if it's the actual
>>>>> function definition but not when it's a prototype.
>>>> 
>>>> I'm not aware of a general recommendation, but the
>>>> __must_check is related to return value and makes sense to
>>>> place it there. There is no other instance of __must_check
>>>> placed at the end of declaratin/definition so I'm applying
>>>> the "be consistent with surrounding code" rule.
>>> 
>>> Putting it at the beginning means indenting the entire
>>> prototype, which I'm not a fan of.
>>> 
>>> - -Jeff
>> 
>> I think it would be much better to put it at the beginning.  For
>> one it's conventional and the rest of the kernel puts it at the
>> beginning. The other, and much more important, thing is that it
>> greatly confuses C indexing tools like cscope.  Now you could
>> argue that those tools' regexes should be tweaked but since it's
>> just a matter of taste why don't put it at the beginning ?
> 
> The rest of the kernel seems to use the beginning.  I don't really
> have a preference, but it's good to use the same standard as the
> rest of the kernel.
> 
> (Sorry Jeff)

Ok. I'll adjust. Thanks for weighing in.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOrqP5AAoJEB57S2MheeWynmgP/33qFEMZcq6AiXp+1JYBwWNu
W725iBRAI1t5cnp7Pgj5Xv+2iccP14lG8dhECBR3g0+xcFI06XetE88jqd3NKPx7
vsKSAt7Txi33NkaihfUPTL07e8HiPgJ9S4MycJ5pZyLCAfmSCbd6NlenZOrsopft
7HVVZKOjDNCSPOjPFGO3NGdaOapfdEkHlImRabpxJQTCNqdrJGCN0+2to30PKQ1Z
Ss2o1tmLdFt+RVSQP9jJ9+zdLnlxqjGMXpI0C103SP+T7GmUJD4XkamPfpMfXNKv
tCHHepRHsqMTERjVXdyu46+Xu0jHfADYIeea/2fXi2XMy88IIsWT/UC3eyeXHaJP
VmykOMnKzcw45r3v1AnAjZ2yqIEwWeGtwz1yXW8vKCALmHrrc+XyI5cRK59jSltf
I/+ghDBw8SycN7e/b+82HCc68VJFoa1vBN4nvvOLrkDiraLwcMgvQvUpdS5vuvSP
aqwhqMtu7qjdw+DxN7oGHEbFzdpIuiHSfAHvW7W4a/SnuRJXqzLMFgqNQ4gyjLAl
6yv/YZ+FqDC2qupZ5Nu6mZXubWI5oEF9p+E0xCTF4NHbbG1rUnnsVTU/xEmZQhcf
2VTZ8+R7g2i61WYxRj9kRZpDAi3zbhMojtN78C2y9pejHDA07FyyTp2vXnbcX7/e
EnsiEPPvcxsUbPH8/osE
=aG23
-----END PGP SIGNATURE-----
