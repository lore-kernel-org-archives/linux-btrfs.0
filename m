From: Tim Gelter <tgelter@gurulabs.com>
Subject: Re: QA suite plans
Date: Fri, 18 Jul 2008 10:36:43 -0600
Message-ID: <4880C69B.7050301@gurulabs.com>
References: <3da3b5b40807160139w4b8e3474te113980d0086ba9c@mail.gmail.com>	 <3da3b5b40807160206h1e07033fu3fba59fd5edd7aa1@mail.gmail.com>	 <20080716120540.GH30311@unused.rdu.redhat.com>	 <3da3b5b40807160622l1f7fe447q3c40219cdae3b18@mail.gmail.com>	 <f058a9c30807170725v10f08ccft85e7427637791077@mail.gmail.com> <3da3b5b40807180930i7808cfc4w3432442ea7e4587f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBAA8C48A051829D68C71067B"
Cc: linux-btrfs@vger.kernel.org
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40807180930i7808cfc4w3432442ea7e4587f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBAA8C48A051829D68C71067B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ahmed Kamal wrote:
> Thanks man, I got myself a wiki account, and get btrfs up and running
> in a VM. Will start planning for the test suite
>=20
> On Thu, Jul 17, 2008 at 5:25 PM, Miguel Sousa Filipe
> <miguel.filipe@gmail.com> wrote:
>> Hi there,
>>
>> On Wed, Jul 16, 2008 at 2:22 PM, Ahmed Kamal
>> <email.ahmedkamal@googlemail.com> wrote:
>>> Ok, cool. If the torture suite is a bunch of scripts, that is probabl=
y
>>> something I can help with. I don't know what's the contribute policy
>>> for this project, but if contributors are welcome I would like to
>>> start a wiki page to gather test suite ideas, and I'd start writing
>>> scripts to execute the tests and report back results
>>>
>>> A bit intro about myself: I come from a "system engineering"
>>> background. I've been introduced to Linux around 10 years ago. I'm an=

>>> RHCE, and currently work as a system engineer, integrating solutions
>>> and consulting on them. I have been involved with the Fedora
>>> community.
>>>
>>> Action Items:
>>> - How do I get access to create a wiki page
>> point your browser to: http://btrfs.wiki.kernel.org
>> create one account there
>>
>>> - Any instructions on checking out the code and building it ?
>> see:
>> http://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
>>
>> To build the code, use make, read the INSTALL file
>>
>>> - I'm planning on using a VM for testing, any specific VMs recommende=
d
>>> (VirtualBox?)
>> not that I know of.
>>
>> Kind regards
>>
>>
>>
>> --
>> Miguel Sousa Filipe
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Hello all,
I've been silently following the development of btrfs for a while now.
After checking out and building the kernel module, I am unable to insmod
it. It complains that it's not of a valid type. Any ideas?
-Tim


--------------enigBAA8C48A051829D68C71067B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUBSIDGoj8ZuWv5QrjKAQKYjAgAmgUlPqDX9OpUhhsHsAMpI56qe0meLzZY
MltHPyiTKKry1vuRCamvYa6WXQpKTmvYfELZJ+f+bMqLEtg+pCUQXn9A1GHPo+Cu
ZK+AiaGiHZ85uA3FQPneUIq4R5RhrdYaHaBsHuLfpAnn/o9k6Rbsu7X1O+UxWtrk
HGJvXxgoneC8LyOHZmnqYFwUHdSEDJZeYczAkVdir77Gs/C6MZERRrEsYsPsy7nn
LGPHvMoVAymrUeRM/y7fpxWA+kDs36KZo4QRQDyAtwKj9chchyjyl1W/nsbBqCGV
GedFR5bn4NBS7oL7EScGtaTSX59vA4XdcFseTdQ3cvpx+KkgGttHNw==
=hFEL
-----END PGP SIGNATURE-----

--------------enigBAA8C48A051829D68C71067B--
