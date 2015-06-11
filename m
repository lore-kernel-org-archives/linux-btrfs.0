Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39872 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbbFKRI5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 13:08:57 -0400
Date: Thu, 11 Jun 2015 17:09:42 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use received_uuid of parent during send
Message-ID: <20150611170942.GK18226@carfax.org.uk>
References: <1433452645-7904-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVcIhgQsEzAXu06J"
In-Reply-To: <1433452645-7904-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--EVcIhgQsEzAXu06J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 04, 2015 at 05:17:25PM -0400, Josef Bacik wrote:
> Neil Horman pointed out a problem where if he did something like this
> 
> receive A
> snap A B
> change B
> send -p A B
> 
> and then on another box do
> 
> recieve A
> receive B
> 
> the receive B would fail because we use the UUID of A for the clone sources for
> B.  This makes sense most of the time because normally you are sending from the
> original sources, not a received source.  However when you use a recieved subvol
> its UUID is going to be something completely different, so if you then try to
> receive the diff on a different volume it won't find the UUID because the new A
> will be something else.  The only constant is the received uuid.  So instead
> check to see if we have received_uuid set on the root, and if so use that as the
> clone source, as btrfs receive looks for matches either in received_uuid or
> uuid.  Thanks,

   While this deals with Neil's problem, there's a few other use-cases
that people have been asking for that (I think) it won't deal with.

   I think ultimately we should be sending all three of the parent
UUID, the parent's Received UUID (if it exists), and the parent's
Parent UUID. That would have to go in the FARv2 update, though.

   However, since this patch doesn't rule out the above happening at
some future date, and I think it'll do the job as described above,

Reviewed-by: Hugo Mills <hugo@carfax.org.uk>

for whatever little it's worth.

   Hugo.

> Reported-by: Neil Horman <nhorman@redhat.com>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/send.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index a1216f9..947d91c 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2328,8 +2328,12 @@ static int send_subvol_begin(struct send_ctx *sctx)
>  	TLV_PUT_U64(sctx, BTRFS_SEND_A_CTRANSID,
>  		    le64_to_cpu(sctx->send_root->root_item.ctransid));
>  	if (parent_root) {
> -		TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
> -				sctx->parent_root->root_item.uuid);
> +		if (!btrfs_is_empty_uuid(parent_root->root_item.received_uuid))
> +			TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
> +				     parent_root->root_item.received_uuid);
> +		else
> +			TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
> +				     parent_root->root_item.uuid);
>  		TLV_PUT_U64(sctx, BTRFS_SEND_A_CLONE_CTRANSID,
>  			    le64_to_cpu(sctx->parent_root->root_item.ctransid));
>  	}
> @@ -4508,8 +4512,21 @@ verbose_printk("btrfs: send_clone offset=%llu, len=%d, clone_root=%llu, "
>  	if (ret < 0)
>  		goto out;
>  
> -	TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
> -			clone_root->root->root_item.uuid);
> +	/*
> +	 * If the parent we're using has a received_uuid set then use that as
> +	 * our clone source as that is what we will look for when doing a
> +	 * receive.
> +	 *
> +	 * This covers the case that we create a snapshot off of a received
> +	 * subvolume and then use that as the parent and try to receive on a
> +	 * different host.
> +	 */
> +	if (!btrfs_is_empty_uuid(clone_root->root->root_item.received_uuid))
> +		TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
> +			     clone_root->root->root_item.received_uuid);
> +	else
> +		TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
> +			     clone_root->root->root_item.uuid);
>  	TLV_PUT_U64(sctx, BTRFS_SEND_A_CLONE_CTRANSID,
>  		    le64_to_cpu(clone_root->root->root_item.ctransid));
>  	TLV_PUT_PATH(sctx, BTRFS_SEND_A_CLONE_PATH, p);

-- 
Hugo Mills             | ... one ping(1) to rule them all, and in the
hugo@... carfax.org.uk | darkness bind(2) them.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                Illiad

--EVcIhgQsEzAXu06J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVecDWAAoJEFheFHXiqx3kTTQQAKFnyjkq5sVq1lV4ZozxTNG/
CRADXyMQc2qHklvCopPKuImK3uW0qcUt4SvjL1PMWgt8v/sivtsTqp6X5XJzTYS9
Dgs2juYZOKjAS1qe8fOw7ti69/9SZnln/D4n1tFDhupCICQiJcdhqgSR1bMKLLmG
muIW5Bin1xxpiuT2MPPtAYo2AGzE/9vKiwCRVTGm0m/A42307bkluUm+OGYBGRMX
iqGztN/1Rf3AgASIlGQfSiU5bBN3LA3ia3P63/VhKeKzRyhGCEdGBw1Rjk3BYcVx
MTw/unrZNcr59Pp5BNZse63jmX7Z8ROHcgCecBMAI+f1jvYCxPozEaxHee3+sodH
aMZG1Akt5lRYznLmcRqenJFJG5RMgF+1AbEA24aVZOiw820q0xaQB0lBWOUpz0L5
kuCbdRhWYFAHPh6yiOBkxk+yJK7ZbpNKZXljMJxN+aLmc0XYANb1QIdM1igKZ/aW
YpxNAdVAF5bigHwo+PP/ZHmsMuSWcwq8OzTgsM78xm49K948IL0fhLqmfCQ5fLnf
lxFp/VqBawaPncAUD3IPEMzbWSN/lZqdMO0E0oKzLqVJ7txgosTw0Ds49Uytpjec
m+fVtqgStfkw6Nm2JA96jySQVgBnieJRpsHt83Zz7/fa2X88hyumRkrbx2CBYyc7
KNuV3Y6S0njVxzutVCiD
=EV44
-----END PGP SIGNATURE-----

--EVcIhgQsEzAXu06J--
