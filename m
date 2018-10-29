Return-Path: <SRS0=e2uI=NJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DDDBC0044C
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 22:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBFAA2082B
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 22:46:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBFAA2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=carfax.org.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbeJ3Hgu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 03:36:50 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:55339 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730244AbeJ3Hgt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 03:36:49 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1gHGII-0005Tj-T8; Mon, 29 Oct 2018 22:45:58 +0000
Date:   Mon, 29 Oct 2018 22:45:58 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Remi Gauvin <remi@georgianit.com>
Cc:     Ulli Horlacher <framstag@rus.uni-stuttgart.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Understanding "btrfs filesystem usage"
Message-ID: <20181029224558.GE21649@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Remi Gauvin <remi@georgianit.com>,
        Ulli Horlacher <framstag@rus.uni-stuttgart.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181029181141.GA31256@rus.uni-stuttgart.de>
 <85a63523-7e77-f4ca-9947-2c957c5c577a@georgianit.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="h56sxpGKRmy85csR"
Content-Disposition: inline
In-Reply-To: <85a63523-7e77-f4ca-9947-2c957c5c577a@georgianit.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--h56sxpGKRmy85csR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 29, 2018 at 05:57:10PM -0400, Remi Gauvin wrote:
> On 2018-10-29 02:11 PM, Ulli Horlacher wrote:
> > I want to know how many free space is left and have problems in
> > interpreting the output of: 
> > 
> > btrfs filesystem usage
> > btrfs filesystem df
> > btrfs filesystem show
> > 
> >
> 
> In my not so humble opinion, the filesystem usage command has the
> easiest to understand output.  It' lays out all the pertinent information.

   Opinions are divided. I find it almost impossible to read, and
always use btrfs fi df and btrfs fi show together.

   There's short tutorials of how to read the output in both cases in
the FAQ, which is where I start out by directing people in this
instance.

   Hugo.

> You can clearly see 825GiB is allocated, with 494GiB used, therefore,
> filesystem show is actually using the "Allocated" value as "Used".
> Allocated can be thought of "Reserved For".  As the output of the Usage
> command and df command clearly show, you have almost 400GiB space available.
> 
> Note that the btrfs commands are clearly and explicitly displaying
> values in Binary units, (Mi, and Gi prefix, respectively).  If you want
> df command to match, use -h instead of -H (see man df)
> 
> An observation:
> 
> The disparity between 498GiB used and 823Gib is pretty high.  This is
> probably the result of using an SSD with an older kernel.  If your
> kernel is not very recent, (sorry, I forget where this was fixed,
> somewhere around 4.14 or 4.15), then consider mounting with the nossd
> option.  You can improve this by running a balance.
> 
> Something like:
> btrfs balance start -dusage=55
> 
> You do *not* want to end up with all your space allocated to Data, but
> not actually used by data.  Bad things can happen if you run out of
> Unallocated space for more metadata. (not catastrophic, but awkward and
> unexpected downtime that can be a little tricky to sort out.)
> 
> 

> begin:vcard
> fn:Remi Gauvin
> n:Gauvin;Remi
> org:Georgian Infotech
> adr:;;3-51 Sykes St. N.;Meaford;ON;N4L 1X3;Canada
> email;internet:remi@georgianit.com
> tel;work:226-256-1545
> version:2.1
> end:vcard
> 


-- 
Hugo Mills             | Great oxymorons of the world, no. 8:
hugo@... carfax.org.uk | The Latest In Proven Technology
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--h56sxpGKRmy85csR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJb142mAAoJEFheFHXiqx3kQz0P/jRhL8ioOfqC3guUWAIT7AUa
NZIgTDho5/X0HO0hKxrfY0bdcojVbbYQ459u5gqKzLcUJJ0DkbCXog5RxV+LAoo+
oUHso0lRQRD9jIMHEX9knTKc6RhfDi6uzecKMhJkz/tSi54n1BdoOrmetPgV3WII
sH5SxOE4mSzpPU2GKyPNpmOiCBr44RuWbK8uT2w5w8gQ9oBCAwW233WjzNrV4KIP
IzlIhsldDQvegn+ExQYmIJAfvPo/Fd75OisR2PxurZLBtqTy87yxw+JA0oA/ONNn
VUuRzT43353RMOAM3AmwPdaV6b2WyuDkui0TEPtQJpAVl+DOMcD2+w4IJm1FHLL+
mZrfmy2kZoLHzSdj31ooovsnUy7ZS88N1XBLdK+VK5lOKB0ZdM/mGGdvdpo5eRZ8
Yu04blPo4qp5VMCS/hNBZAzRg/oEqVqmwLM8ARY9Yafxs5OWQvnu8emNaFCiOn/i
l77flpQ4fMxVRIPSyQ/sRPEbhc+xdc/b7F/NfaIwMVTidr1Z8XHQn6PtkQ/qmbhu
Z8M4L43s3iVCRK2Rwa4wlFKjWX5WFD0ftZOlPcbmwBLaPgvOhNI0mbv5HN8/ZDTh
OOpOzgSRB71n5BEbOo4bavHP64fOtOGbrAl0CCAOI/BV3Ekdm9cnmXQmpowjCEwl
ezz1HftU9BYUIW1vksZY
=zTAh
-----END PGP SIGNATURE-----

--h56sxpGKRmy85csR--
