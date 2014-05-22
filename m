Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbaEVQGZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 12:06:25 -0400
Message-ID: <537E2081.9080007@redhat.com>
Date: Thu, 22 May 2014 11:06:25 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: Anand Jain <Anand.Jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] btrfs: label should not contain return char
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>	<1400567808-9494-1-git-send-email-anand.jain@oracle.com>	<537B83AD.5010901@redhat.com>	<537D5B55.1010207@oracle.com>	<537D5D6F.900@redhat.com> <20140522101431.6b2a9ee2@natsu>
In-Reply-To: <20140522101431.6b2a9ee2@natsu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/21/14, 11:14 PM, Roman Mamedov wrote:
> On Wed, 21 May 2014 21:14:07 -0500
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>>>> (Random aside: why does btrfs support online fs relabeling, anyway?)
>>>>
>>>> -Eric
>>>
>>>   Online you mean when mounted ?
>>
>> Yep - I'm just not sure who would ever want to do that.
>>
>> Aren't labels primarly used for mounting, during the mount process?
> 
> Well if you want to change the label of your root filesystem, how else would
> you go about that? If Btrfs did not support this, then only while booted from a
> rescue LiveCD? That's quite a bit more involved and not even always feasible
> in case of remote machines with no IPMI or similar management.
> 
> Extfs supports online change of the volume label as well, albeit probably not
> via a sysfs file, but with the tune2fs utility:
> 
>   tune2fs -L <name> /dev/blockdevice

Yeah, that just writes directly to the block device.  :)
But ok, I guess relabeling root is a fair case.

- -Eric
 


-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTfiCAAAoJECCuFpLhPd7gAHoP/AlFeFJ8Om0wKxcnuolG7o4G
9AHRu4Jto8JTHWToOwmtJAcWQFS+fJtUF009cl118eb+vUOoWFdTDK3H8UiC6uwM
/OcFaeDRJOg4JEA8OBaXihCoG1JOPU2ygCezyg59mbHV6SFIYy4kDgqzfFm6qcaC
8vqenmPkGhYiIadvPeDYctIPGS6DquLjxKk/xI52gLwP6so2eJ9nH4jmO7K1gF6n
dRa7zfCDpcMq5AqiJW5XZWBfmuNH5etGgJW8J4JpuOSzYPECwuHzcXP3LZny/xUP
t15LxzUR+0SZg04zJYXY5YoytZaz6mfk0jOksggeY9GiDenlWUZhDi/QexIhc2ZL
ZuHt8WDWDtIqt4D84GE/9QlI5tVU+F8FkJBnPSS+ybP8YSShNWmIdKLVtn+4g8/x
YVC6PnUyYvLj/1ZSJTGUQtJZkSjsfkRISk3ygVz1NJQG75euRL2gxmZkn11497rU
rc4a+yZQ3Gxe0cOn1J8RzN9dDQ3iIQnM7Fn25vFdn/uN1dPuQuDP3zy9MG4WJD8e
3xX1HNiXePgZGN5bhaCLXqAER6E4Xigd5mcdjuXZvmkexEkTRn3xOcXuoDhU8v2i
Oloroh09tpMmzw4sNyaeqw11oIkBcUEvY/7ggqYEtZcOAtnFuyot9y5LUIgNmtBM
Sas6/mxzXeTPCApF1o1a
=sUri
-----END PGP SIGNATURE-----
