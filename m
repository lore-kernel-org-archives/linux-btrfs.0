Received: from 11.mo533.mail-out.ovh.net (11.mo533.mail-out.ovh.net [87.98.181.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D013A8757
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 17:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=87.98.181.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773422517; cv=none; b=nPVwbLrk5KsDmV6PMioSaU0ftQJen+RRmd79kYbovDAuSolGHyn/xYqGb62iC+1iqgJxmaQzZbdGUmrON7y90cDqJhK2ctJkzwmTY7vE8jU5Y9YsgUZRWbG6s4Ivob3T7DW7Qu3gODZGr/xg7gu1AKEGSyXs3WeotDsN9LeUa0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773422517; c=relaxed/simple;
	bh=o9C8GlaQINVvOBi8fo+i1hg6qc0ZSM+TwzJ3qKNbgeA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OMTIb7xtXdEXIgLJOorXUd6tp5dDqmWGzARNgqHccOAGWLkyzbnZK7M3t3HL3XDUxrHPfB6VHQz7urs0FL2jUIWV2X4Ut462ZBIufn3tabCgEBk4ZlC3tGekTBk4zHLLXUiUThMhXunvOSnyA3Wgd9SpJKqZX6QIcAGO2b1X7HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=guillain.net; spf=pass smtp.mailfrom=guillain.net; dkim=pass (2048-bit key) header.d=guillain.net header.i=@guillain.net header.b=VcJ55QOy; arc=none smtp.client-ip=87.98.181.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=guillain.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=guillain.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=guillain.net header.i=@guillain.net header.b="VcJ55QOy"
Received: from director1.derp.mail-out.ovh.net (director1.derp.mail-out.ovh.net [51.68.80.175])
	by mo533.mail-out.ovh.net (Postfix) with ESMTPS id 4fXWJ432gkz5yPV;
	Fri, 13 Mar 2026 17:12:20 +0000 (UTC)
Received: from director1.derp.mail-out.ovh.net (director1.derp.mail-out.ovh.net. [127.0.0.1])
        by director1.derp.mail-out.ovh.net (inspect_sender_mail_agent) with SMTP
        for <dsterba@suse.com>; Fri, 13 Mar 2026 17:12:20 +0000 (UTC)
Received: from mta11.priv.ovhmail-u1.ea.mail.ovh.net (unknown [10.110.37.222])
	by director1.derp.mail-out.ovh.net (Postfix) with ESMTPS id 4fXWJ40whfz5xTh;
	Fri, 13 Mar 2026 17:12:20 +0000 (UTC)
Received: from guillain.net (unknown [10.1.6.9])
	(Authenticated sender: jean-christophe@guillain.net)
	by mta11.priv.ovhmail-u1.ea.mail.ovh.net (Postfix) with ESMTPSA id 81B5B9A13A8;
	Fri, 13 Mar 2026 17:12:19 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-97G002a3a49725-80a7-446e-b7c9-4b020084ec8f,
                    E50281848AA3A500EAF2CA0FEADB084EFD0FEAE0) smtp.auth=jean-christophe@guillain.net
X-OVh-ClientIp:78.240.83.207
Message-ID: <f49e0f4fc028966240c191ef59bf5c4e935c06a9.camel@guillain.net>
Subject: Re: [PATCH v2] btrfs: zlib: handle page aligned compressed size
 correctly
From: Jean-Christophe Guillain <jean-christophe@guillain.net>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org, David Sterba <dsterba@suse.com>
Date: Fri, 13 Mar 2026 18:12:18 +0100
In-Reply-To: <ab5c12312b275589abd42c47a0c34b7e68375407.1773389056.git.wqu@suse.com>
References: 
	<ab5c12312b275589abd42c47a0c34b7e68375407.1773389056.git.wqu@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
x-ovh-tracer-id: 5004625086269115163
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTGrwVLVG0zrFrVwavWGXqEXkpmNbZVtBW5sheGeDHqR6feMA25pEWiYjzizTTXaQe06b+7YXr/AxFg1TSvne1g2W5WaNVLcAXIq207VtwMFdLQEEr2gbuktLYw5VauxRHQ7FLG7El53fyrtjkep4eW22tjUjbyjwKA0JztosTBG8+e/OXDdjljb1OQqLMUI7BFApTuEtcv4Ywx2gHaOnJrbLSDyuo4/RlmRTiedeDDrXgHlxnJx/RqlhVbRJuHJIcJe3OhZgXh7ew76ZzQpH9ShvBm8qSPabfcv8FO0+tJDvzbHoOCaUFMGMB/T2t1u+AJOz02jzeheQtgahOKKYkZDPR0SaUIj2Jf0gQZu4nWl7SmaXehrXDtjbm+jRpHi2SIV1e8xA5yshpy9M6trGO0ZStL8xjsEyhnlzBGW+d9lWOVO4x9NezH6yJek2MQWq5SMWufIxYIj4MQWzkF/S44l7KTL3UQJ3UQS/drbqEak9jmbB1F6Fr4en3Gd8SfhIf+twUV1cz1C14FOIKPrPnleYxkfN0CTi//a33TeF85SHymCpDmqGredZLErXSRed283tH9uurBPqWgf5naiT7ev/FePVQgjYwzDmol1MH5ohaM+5dQ/mLiUvGOE6vCU8lf/aw8clZ6+mFKZsOqbqPWLp/bJveAkaV10u2LHAF8kNw
DKIM-Signature: a=rsa-sha256; bh=o9C8GlaQINVvOBi8fo+i1hg6qc0ZSM+TwzJ3qKNbgeA=;
 c=relaxed/relaxed; d=guillain.net; h=From; s=ovhmo31693-selector1;
 t=1773421940; v=1;
 b=VcJ55QOynT/YNcI+lR2/eCPNdjIcFWwR78Uo/XGFexmZ5IQWR+pWkre/qYlBwtpkd07syZKm
 KaiA83j34K0Q8b6FQRU4sVGZzyxN+NdTEWDb1eROcYAg95kvx9cq2mcrNEWy8bsw+8T4bH0Y64e
 1XacdFVuTEBe821N6X+1uoEhYyzinmuiHV5qZkoRrrqRr1Ejf6rYcEtHw83EPpjXWjdL6TO0hiQ
 1wGfckRTe9xjm8CTqNqpbh8HKm9CEoPFgALUmdnpEP7QGRrJnKpS7UQwGykJS/RkYmncrznB8QQ
 AP7Z5U6dNI01arnGvop0pQvcEh89h90/scumS6UBj9KXg==

On Fri, 2026-03-13 at 18:35 +1030, Qu Wenruo wrote:
> [FIX]
> Instead of offset_inside_folio(), directly use the difference between
> strm.total_out and bi_size.
> So that if the last folio is completely full, we can still properly
> queue the full folio other than queueing zero byte.
>=20
> Fixes: 3d74a7556fba ("btrfs: zlib: introduce zlib_compress_bio()
> helper")
> Cc: stable@vger.kernel.org=C2=A0# 7.0+
> Reported-by: David Sterba <dsterba@suse.com>
> Reported-by: Jean-Christophe Guillain <jean-christophe@guillain.net>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D221176
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Add missing reported-by/link/cc tags

This patch (applied on 7.0.0-rc3) fixed the bug for me.
(The uptime of my workstation is more than 5 hours now ; it didn't work
more than 40 minutes before.)

Thank you very much,
Jean-Christophe
