Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C44C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 12:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A888C206C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 12:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391450AbfAPMBR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:01:17 -0500
Received: from frost.carfax.org.uk ([85.119.82.111]:38506 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390001AbfAPMBR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 07:01:17 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1gjjsg-00088V-0X; Wed, 16 Jan 2019 12:01:14 +0000
Date:   Wed, 16 Jan 2019 12:01:13 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Leonard Lausen <leonard@lausen.nl>
Subject: Re: [PATCH] btrfs: Do mandatory tree block check before submitting
 bio
Message-ID: <20190116120113.GG5134@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Leonard Lausen <leonard@lausen.nl>
References: <20190116115308.8687-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rV8arf8D5Dod9UkK"
Content-Disposition: inline
In-Reply-To: <20190116115308.8687-1-wqu@suse.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--rV8arf8D5Dod9UkK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Qu,

On Wed, Jan 16, 2019 at 07:53:08PM +0800, Qu Wenruo wrote:
> There are at least 2 reports about memory bit flip sneaking into on-disk
> data.
> 
> Currently we only have a relaxed check triggered at
> btrfs_mark_buffer_dirty() time, as it's not mandatory, only for
> CONFIG_BTRFS_FS_CHECK_INTEGRITY enabled build.
> 
> This patch will address the hole by triggering comprehensive check on
> tree blocks before writing it back to disk.
> 
> The timing is set to csum_tree_block() where @verify == 0.
> At that timing, we're generation csum for tree blocks before submitting
> the metadata bio, so we could avoid all the unnecessary calls at
> btrfs_mark_buffer_dirty(), but still catch enough error.

   I agree wholeheartedly with the idea of this change. Just one
question:

   How does this get reported to the user/administrator? As I
understand it, a detectably corrupt metadata page will generate an I/O
error from the filesystem before it's written to disk? How will this
show up in kernel logs? Is it distinguishable in any way from a
similar error that was generated on reading such a corrupt metadata
node from the disk?

   Basically, I want to be able to distinguish this case (error
detected when writing) from the existing case (error detected when
reading) when someone shows up on IRC with a "broken filesystem".

   Hugo.

> Reported-by: Leonard Lausen <leonard@lausen.nl>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8da2f380d3c0..45bf6be9e751 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -313,6 +313,16 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
>  			return -EUCLEAN;
>  		}
>  	} else {
> +		/*
> +		 * Here we're calculating csum before writing it to disk,
> +		 * do comprenhensive check here to catch memory corruption
> +		 */
> +		if (btrfs_header_level(buf))
> +			err = btrfs_check_node(fs_info, buf);
> +		else
> +			err = btrfs_check_leaf_full(fs_info, buf);
> +		if (err < 0)
> +			return err;
>  		write_extent_buffer(buf, result, 0, csum_size);
>  	}
>  

-- 
Hugo Mills             | ... one ping(1) to rule them all, and in the
hugo@... carfax.org.uk | darkness bind(2) them.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                Illiad

--rV8arf8D5Dod9UkK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcPx0JAAoJEFheFHXiqx3kopIP/36cnoVzP+5biYoYywjFlHzv
7vICIZvg3kfNNBXLmf7kn34N4VXfMqHt5+zL32QP6eK8/smG0lTFV4ZDGoMYoENk
L+oR8kq/AH4doZ1VpDlLaHKU4Fssj2I0ZAk5inzwWl/hy9lkVU5K+f4fmcXRrtnD
bE4UfOtt/QZ4G8ALf+4VWNuCsRaCg/pVO/ScorJqZVYXD8zVeB3vdZkZDRM/LEUt
7QZX5h1n+NE/jLPIcRPAytOjfQTVnP3gVsBZkbvaIdn3CGyUlC8hr/+dksUNHABV
MZPeoJaSGdFj9mRMRDSrDJhy77qNasg0b5X10GoR7xMrXWudaCskTl5uCJ0dpSy2
5ScssMGJwHpXhUZjxtF8ie2+0E0yqvl3pL+1eTcbNrWePvMQsGLBkvSCk4KMj8Xc
+0yHHMpYpdeLP+A0nFGjtF0GrTwhPuORkh9KuzonJQnlD1vdkCTYwFyxdjB7h8KC
sNO1OWcgf91+aPJRhq1oIx/DcOEPnvmochG2pL6WpCWELGrheP1C6A7Pkx+JA5sm
utwVB3P+jIkg46a4mTtoCWyshSORUXMWNVz2nd5soTJ4Z4XYtXErAjx5CZScJ/Y7
h17yP+7pC/Ue2VN1Js1+AYPSSBgg57hxxXs8i83CT63kQ337azCq32jSxpoU6wUG
L/3+bf5Eu1iA4NfEwPSg
=vz0h
-----END PGP SIGNATURE-----

--rV8arf8D5Dod9UkK--
