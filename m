From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: [PATCH] Add supported kernel version check to mkfs.btrfs
Date: Thu, 23 Jul 2009 15:50:44 +0200
Message-ID: <D102393B-AFF2-4771-822E-71D3762A1B45@karlsbakk.net>
References: <20090723023411.23E8A8C03F@csamuel.org>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	delsp=yes
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090723023411.23E8A8C03F@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 23. juli. 2009, at 04.09, Chris Samuel wrote:

> +	if ( kern_major > min_major )
> +		return( 0 );
> +	if ( kern_major < min_major )
> +		return( -1 );
> +	if ( kern_medium > min_medium )
> +		return( 0 );
> +	if ( kern_medium < min_medium )
> +		return( -1 );
> +	if ( kern_minor < min_minor )
> +		return( -1 );
> +
> +	return( 0 );


Why not simply this?

if (kern_major < min_major || kern_medium < min_medium || kern_minor < =
=20
min_minor)
         return -1;

return 0;
--
Roy Sigurd Karlsbakk
(+47) 97542685
roy@karlsbakk.net
http://blogg.karlsbakk.net/
--
I all pedagogikk er det essensielt at pensum presenteres =20
intelligibelt. Det er et element=E6rt imperativ for alle pedagoger =E5 =
=20
unng=E5 eksessiv anvendelse av idiomer med fremmed opprinnelse. I de =20
fleste tilfeller eksisterer adekvate og relevante synonymer p=E5 norsk.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
