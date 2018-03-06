Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57774 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932589AbeCFO7O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Mar 2018 09:59:14 -0500
Subject: Re: [PATCH 0/8] btrfs-progs: qgroups usability [corrected]
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <7fe42c8a-755c-099a-d430-0cae7e24b69b@gmx.com>
From: Jeffrey Mahoney <jeffm@suse.com>
Message-ID: <827bbca4-0f2f-a079-f166-f5207362b12b@suse.com>
Date: Tue, 6 Mar 2018 09:59:09 -0500
MIME-Version: 1.0
In-Reply-To: <7fe42c8a-755c-099a-d430-0cae7e24b69b@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UQTSzeYuzHpINrlJQ0yiVptiD8wD6l17P"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UQTSzeYuzHpINrlJQ0yiVptiD8wD6l17P
Content-Type: multipart/mixed; boundary="dyMHd3uNrajRHGaTNEBiqe70f0nGjjZRZ";
 protected-headers="v1"
From: Jeffrey Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <827bbca4-0f2f-a079-f166-f5207362b12b@suse.com>
Subject: Re: [PATCH 0/8] btrfs-progs: qgroups usability [corrected]
References: <20180302184704.22399-1-jeffm@suse.com>
 <7fe42c8a-755c-099a-d430-0cae7e24b69b@gmx.com>
In-Reply-To: <7fe42c8a-755c-099a-d430-0cae7e24b69b@gmx.com>

--dyMHd3uNrajRHGaTNEBiqe70f0nGjjZRZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/6/18 7:10 AM, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B403=E6=9C=8803=E6=97=A5 02:46, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> Hi all -
>>
>> The following series addresses some usability issues with the qgroups =
UI.
>>
>> 1) Adds -W option so we can wait on a rescan completing without starti=
ng one.
>> 2) Adds qgroup information to 'btrfs subvolume show'
>> 3) Adds a -P option to show pathnames for first-level qgroups (or memb=
er
>>    of nested qgroups with -v)
>> 4) Allows exporting the qgroup table in JSON format for use by externa=
l
>>    programs/scripts.
>=20
> Going to review the patchset in the following days, but I'm pretty
> curious about this feature.
>=20
> Is there any plan to implement similar json interface for other tools?
> Or just qgroup only yet?

Dave and I talked about this off-list yesterday.  I had asked if perhaps
we'd want things like "btrfs subvolume list" and "btrfs subvolume show",
among other commands, to also offer JSON output.  We agreed that the
answer is "yes" and that we should use something like a global option
like "--format=3Djson" to do that, e.g. "btrfs --format=3Djson qgroup sho=
w."
   I have patches partially worked up to implement that.  The idea is
that commands would define in their flags which output formats they
accept.  If the user requests an unsupported format, they would receive
an error with usage, listing the accepted formats.  Each command is
responsible for outputting in a given format, but that doesn't mean we
couldn't standardize on a common library for most commands.  Dave and I
discussed using libsmartcols for output since it supports tabular and
JSON output.  For qgroups show, where we want to provide different data
structures for level 0 qgroups vs nested qgroups, it's unsuitable.  For
simple tables like 'subvolume show' or 'subvolume list' it could
probably work well.

One question I had was whether errors should be reported in the
requested format.  I'm inclined to say no and that's what my code does:
errors are still reported in plaintext with a nonzero error code.

-Jeff

>> Jeff Mahoney (8):
>>   btrfs-progs: quota: Add -W option to rescan to wait without starting=

>>     rescan
>>   btrfs-progs: qgroups: fix misleading index check
>>   btrfs-progs: constify pathnames passed as arguments
>>   btrfs-progs: qgroups: add pathname to show output
>>   btrfs-progs: qgroups: introduce and use info and limit structures
>>   btrfs-progs: qgroups: introduce btrfs_qgroup_query
>>   btrfs-progs: subvolume: add quota info to btrfs sub show
>>   btrfs-progs: qgroups: export qgroups usage information as JSON
>>
>>  Documentation/btrfs-qgroup.asciidoc |   8 +
>>  Documentation/btrfs-quota.asciidoc  |  10 +-
>>  Makefile.inc.in                     |   4 +-
>>  chunk-recover.c                     |   4 +-
>>  cmds-device.c                       |   2 +-
>>  cmds-fi-usage.c                     |   6 +-
>>  cmds-qgroup.c                       |  49 +++-
>>  cmds-quota.c                        |  21 +-
>>  cmds-rescue.c                       |   4 +-
>>  cmds-subvolume.c                    |  46 ++++
>>  configure.ac                        |   6 +
>>  kerncompat.h                        |   1 +
>>  qgroup.c                            | 526 +++++++++++++++++++++++++++=
+++------
>>  qgroup.h                            |  22 +-
>>  send-utils.c                        |   4 +-
>>  utils.c                             |  22 +-
>>  utils.h                             |   2 +
>>  17 files changed, 621 insertions(+), 116 deletions(-)
>>
>=20



--dyMHd3uNrajRHGaTNEBiqe70f0nGjjZRZ--

--UQTSzeYuzHpINrlJQ0yiVptiD8wD6l17P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqerL4PHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWy9KoP/icfACKaVhXfzNCk5bIGLzQt/K4nWJkH0UyT
ZVyXoZvWpds5yJpx/yTgc6T2dbENkfHCfS/gyIRa1qlw8oiLOMepqaWRsUAj8fp4
WEb1MdDAa/t2CwKWrxbuLw79B+A2aRCPovLT/DDmuj28LbKnbg5T0mkJ5r7w68aS
RlkseKkZ1m2fM79pCcOH+h6iUP4M5asFnwNjxOnU1Sli7jfeCwNBEgXMqvpUvyv+
QcLQ9Yb08f2xpvCXiX75o8sQ2sJp18qJYpGiywRUnZGgLIz6l/Rd3nQRIAgATBLu
ap5b16iHvQ4O+WzYgGIvgXZigDuARlxmcAFxh4Y1pdTYvkcGwZIsqa3e4eAC6nAi
iI/gJ6gbPIMTHXxsgdP6m+PCSmhLQ6QFs+t4MBZ+4Rf+TAWjl/cxBLwLY7dLl5vW
HdER0EKSjhFm0b3jTaGA9GjDgy5rPhPXLXNIx6HGL4dTVq1a61dll2rBBJ0zhrJD
oSy1YieRhwKbzdldY1hggXP4VjKJ+53397XUZ6LTboBkG3yIOR89T+89dHYAHxlt
rzM2sV8EDYuWwEWggQkbPmFgcXUC58roLmoPFuw4BhPDIIKLm2nfhrEPjqTVIYtD
RC7NLvYLddJ7cXY1X/V212ZPF+RhDFxBJz2a/eznC2Q/urOazZwZMwT3wxykZv7Q
pIKpreiU
=apMx
-----END PGP SIGNATURE-----

--UQTSzeYuzHpINrlJQ0yiVptiD8wD6l17P--
