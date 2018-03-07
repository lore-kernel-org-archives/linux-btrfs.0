Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50410 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934297AbeCGUqB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 15:46:01 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E2641AEF9
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Mar 2018 20:45:59 +0000 (UTC)
Subject: Re: [PATCH 3/8] btrfs-progs: constify pathnames passed as arguments
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-4-jeffm@suse.com>
 <2d41799e-227d-95bb-2f17-a67d4ad2e35e@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <38d2b435-e52d-672f-c2ae-96ffb154baa4@suse.com>
Date: Wed, 7 Mar 2018 15:45:52 -0500
MIME-Version: 1.0
In-Reply-To: <2d41799e-227d-95bb-2f17-a67d4ad2e35e@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AKbcJIXrSq5x5uPUbXLJsy4mtBFXzruPh"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AKbcJIXrSq5x5uPUbXLJsy4mtBFXzruPh
Content-Type: multipart/mixed; boundary="gKmPBHatXRVylVTMNpKsTlBuYvk7UX23U";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <38d2b435-e52d-672f-c2ae-96ffb154baa4@suse.com>
Subject: Re: [PATCH 3/8] btrfs-progs: constify pathnames passed as arguments
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-4-jeffm@suse.com>
 <2d41799e-227d-95bb-2f17-a67d4ad2e35e@suse.com>
In-Reply-To: <2d41799e-227d-95bb-2f17-a67d4ad2e35e@suse.com>

--gKmPBHatXRVylVTMNpKsTlBuYvk7UX23U
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/7/18 3:17 AM, Nikolay Borisov wrote:
>=20
>=20
> On  2.03.2018 20:46, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> It's unlikely we're going to modify a pathname argument, so codify tha=
t
>> and use const.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  chunk-recover.c | 4 ++--
>>  cmds-device.c   | 2 +-
>>  cmds-fi-usage.c | 6 +++---
>>  cmds-rescue.c   | 4 ++--
>>  send-utils.c    | 4 ++--
>>  5 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/chunk-recover.c b/chunk-recover.c
>> index 705bcf52..1d30db51 100644
>> --- a/chunk-recover.c
>> +++ b/chunk-recover.c
>> @@ -1492,7 +1492,7 @@ out:
>>  	return ERR_PTR(ret);
>>  }
>> =20
>> -static int recover_prepare(struct recover_control *rc, char *path)
>> +static int recover_prepare(struct recover_control *rc, const char *pa=
th)
>>  {
>>  	int ret;
>>  	int fd;
>> @@ -2296,7 +2296,7 @@ static void validate_rebuild_chunks(struct recov=
er_control *rc)
>>  /*
>>   * Return 0 when successful, < 0 on error and > 0 if aborted by user
>>   */
>> -int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
>> +int btrfs_recover_chunk_tree(const char *path, int verbose, int yes)
>>  {
>>  	int ret =3D 0;
>>  	struct btrfs_root *root =3D NULL;
>> diff --git a/cmds-device.c b/cmds-device.c
>> index 86459d1b..a49c9d9d 100644
>> --- a/cmds-device.c
>> +++ b/cmds-device.c
>> @@ -526,7 +526,7 @@ static const char * const cmd_device_usage_usage[]=
 =3D {
>>  	NULL
>>  };
>> =20
>> -static int _cmd_device_usage(int fd, char *path, unsigned unit_mode)
>> +static int _cmd_device_usage(int fd, const char *path, unsigned unit_=
mode)
>=20
> Actually the path parameter is not used in this function at all, I'd sa=
y
> just remove it.

Yep, it's unused, but that's a different project.  Add
-Wunused-parameter and see what shakes out. :)

>>  {
>>  	int i;
>>  	int ret =3D 0;> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
>> index de7ad668..9a1c76ab 100644
>> --- a/cmds-fi-usage.c
>> +++ b/cmds-fi-usage.c
>> @@ -227,7 +227,7 @@ static int cmp_btrfs_ioctl_space_info(const void *=
a, const void *b)
>>  /*
>>   * This function load all the information about the space usage
>>   */
>> -static struct btrfs_ioctl_space_args *load_space_info(int fd, char *p=
ath)
>> +static struct btrfs_ioctl_space_args *load_space_info(int fd, const c=
har *path)
>>  {
>>  	struct btrfs_ioctl_space_args *sargs =3D NULL, *sargs_orig =3D NULL;=

>>  	int ret, count;
>> @@ -305,7 +305,7 @@ static void get_raid56_used(struct chunk_info *chu=
nks, int chunkcount,
>>  #define	MIN_UNALOCATED_THRESH	SZ_16M
>>  static int print_filesystem_usage_overall(int fd, struct chunk_info *=
chunkinfo,
>>  		int chunkcount, struct device_info *devinfo, int devcount,
>> -		char *path, unsigned unit_mode)
>> +		const char *path, unsigned unit_mode)
>>  {
>>  	struct btrfs_ioctl_space_args *sargs =3D NULL;
>>  	int i;
>> @@ -931,7 +931,7 @@ static void _cmd_filesystem_usage_linear(unsigned =
unit_mode,
>>  static int print_filesystem_usage_by_chunk(int fd,
>>  		struct chunk_info *chunkinfo, int chunkcount,
>>  		struct device_info *devinfo, int devcount,
>> -		char *path, unsigned unit_mode, int tabular)
>> +		const char *path, unsigned unit_mode, int tabular)
>>  {
>>  	struct btrfs_ioctl_space_args *sargs;
>>  	int ret =3D 0;
>> diff --git a/cmds-rescue.c b/cmds-rescue.c
>> index c40088ad..c61145bc 100644
>> --- a/cmds-rescue.c
>> +++ b/cmds-rescue.c
>> @@ -32,8 +32,8 @@ static const char * const rescue_cmd_group_usage[] =3D=
 {
>>  	NULL
>>  };
>> =20
>> -int btrfs_recover_chunk_tree(char *path, int verbose, int yes);
>> -int btrfs_recover_superblocks(char *path, int verbose, int yes);
>> +int btrfs_recover_chunk_tree(const char *path, int verbose, int yes);=

>=20
> That path argument is being passed to recover_prepare which can alo use=

> a const to its path parameter

Yep, and it was in the first chunk.

>> +int btrfs_recover_superblocks(const char *path, int verbose, int yes)=
;
>> =20
>>  static const char * const cmd_rescue_chunk_recover_usage[] =3D {
>>  	"btrfs rescue chunk-recover [options] <device>",
>> diff --git a/send-utils.c b/send-utils.c
>> index b5289e76..8ce94de1 100644
>> --- a/send-utils.c
>> +++ b/send-utils.c
>> @@ -28,8 +28,8 @@
>>  #include "ioctl.h"
>>  #include "btrfs-list.h"
>> =20
>> -static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *pat=
h_len,
>> -				      u64 subvol_id);
>> +static int btrfs_subvolid_resolve_sub(int fd, char *path,
>> +				      size_t *path_len, u64 subvol_id);
>=20
> This seems like an unrelated change. As a matter of fact
> btrfs_subvolid_resolve_sub is used only by btrfs_subvolid_resolve. So i=
f
> you move the latter after the former then you can drop the declaration
> at the beginning of the file altogether.

Ah, yep.  That's the fallout from adding const, reformatting, and
removing it.  I'll just skip it entirely.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--gKmPBHatXRVylVTMNpKsTlBuYvk7UX23U--

--AKbcJIXrSq5x5uPUbXLJsy4mtBFXzruPh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqgT4EPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWybNMP/0Bem+eDqUMjtzM5TW5BMfRVXAFZRaFSRnX8
XJXNvfsJnaROoWGFJk2bWSE37wh3yN7VKajNAn/kFOyA78GOiGObwA6kpmMN0WLn
lpxdd5//UAtiiH2upbDOTvc+c9SwaapUrrSXfNowr9fDbEqNC50cSwP4P9iR6W+I
4ncL+tlZbdqMx4hw/2qHLwEgeWZEAOZN8jk1sdWuIr1KyXrEvDJMX8vqoC3ddx0K
R0gTqgCqhW8OskuDWSF+8welzyunBtZD+/Op2zbxMJKfLc6KKTMTq5Dmje1SZGHc
TxIze9htn1EpxuNFtzoXWRmuaTCn0nWmmbNW0tVUPHWWdrrftt7qb6bneoiZhZjk
V2rAn+YpeLRafiBIK6RAsDQ9+sTZR7wvSohVeyWrm4tm5hU0BbW+vaC+Z9Teeb/r
NLKJ+ZA8gDSrTw+ZmpyuZTCy+y0Njxj8xJmWSO2ezq0el8LpSxZ6loc0K6/O7P3n
IOHircDLzXMJY8a67tWPIL+nWYL3lLommURN9OcEZshmJ0lPMkpWzmTygXbpljag
zDBVx5B/dMR7TCm568dIWBsAATA70fgQ+Scx3G7D5CECVV1T7lwR+EAIT4+5E3TB
ymhOFrt3FxIwgG4PlAMnaJOC2vGUHOP0w5e+7O0xiA26EXfIyBKvAerXR138q9XD
0PbieQnW
=5E3o
-----END PGP SIGNATURE-----

--AKbcJIXrSq5x5uPUbXLJsy4mtBFXzruPh--
