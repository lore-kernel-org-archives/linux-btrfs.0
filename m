From: jim owens <jowens@hp.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 10:44:42 -0400
Message-ID: <48FF3C5A.2090106@hp.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <1224597580.27474.93.camel@think.oraclecorp.com>	 <20081021182710.a12f4914.skraw@ithnet.com>	 <1224611383.27474.140.camel@think.oraclecorp.com>	 <20081022141906.f6529c6d.skraw@ithnet.com> <1224683433.6448.36.camel@think.oraclecorp.com> <48FF32DA.2010103@waechter.wiz.at> <48FF396B.6000000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: =?UTF-8?B?TWF0dGhpYXMgV8OkY2h0ZXI=?= <matthias@waechter.wiz.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF396B.6000000@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ric Wheeler wrote:
> Matthias W=C3=A4chter wrote:
>> On 10/22/2008 3:50 PM, Chris Mason wrote:
>>
>> =20
>>> Let me reword my answer ;).  The next write will always succeed unl=
ess
>>> the drive is out of remapping sectors.  If the drive is out, it is =
only
>>> good for reads and holding down paper on your desk.
>>>    =20
>>
>> I have a fairly new SATA disk with about 3000 hours of 24/7 duty
>> (very light load), 0 remapped sectors and 8 consecutive sectors with
>> read/write errors. Still, it did not perform remapping facing heavy
>> writes on the bad sectors. Now what? For whatever reason, remapping
>> not always works (or mine was produced with a total of zero
>> remapping sectors=E2=80=A6).
>>
>> - Matthias
>>  =20
>=20
> It sounds like this drive is actually fine, you might have seen some=20
> transient issues.
>=20
> Are you positive that the writes went directly to the sectors in=20
> question - that should either clear the error or cause it to remap th=
e=20
> sectors internally. (Reads will continue to fail).
>=20
> Mark Lord has added some options to hdparm that you might be able to =
use=20
> to expressly clear the sectors in question in a more direct way.

let me add 2 other thoughts from my experience with other drive types:

    - check for firmware updates.

    - some drives have a remapping mode where it fails the write,
      reports to the host, then the host will send a remap-this-sector
      command.  this mode might be selectable on the drive. if the
      host driver does not do the remap that sector will continue
      to fail.

jim
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
