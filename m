Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DF63AC0C6
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 08:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776070005; cv=none; b=u6NeV3uh5plPHca/DvuWYoZQbclcA4vFwX6+WZUdklArBZ4bLIy43Q/aJIpbwi0v7wSBTyoyobB1JXlzlupFrFKj6ekOorfGT61NcCFnZStHny2QCjQ9eenuSgfl3ItXX7h9j3OJegTXmvpQN9FXNEobU7sOwJ8v/mIyJAszlHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776070005; c=relaxed/simple;
	bh=O2uRfGLEhdnBw4pMGNCjQnMW5VTUhDYrxR4DJ/TPLd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QY7cczMEBkEXbac37JcymIWl4WsdPUs5HUxzGA3Qo8n3v+uS6XG1A8sz9bgc0v82Cie5lv2SiA8IowmLWwzuAX1N6rX+SFCQSgILQQBh7AeW3ZwwLAZCQVMR6Ohxn5cX4uaeIG/oHX/HYPQYl2yDe1VD9xfOkmymaPQAZHMyAs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3JH9s5Uf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=k/eGmCKT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3JH9s5Uf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=k/eGmCKT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3JH9s5Uf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="k/eGmCKT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3JH9s5Uf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="k/eGmCKT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3C37E6A891;
	Mon, 13 Apr 2026 08:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776070002; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5agqwrJT2AkhcCX6tI8RQWaticWktVRky7unduqbP58=;
	b=3JH9s5UfURzKVTl6JkyrKDL6Fj9s3sYm6bRkyrbQ6jONbBGSq2wYSokinRtQCmRNqWikSZ
	FsK3aL6TsShrp1ieISWoNir+3MD3AHMF0QS+DjKGRvcaRcDIKe3+r4dWwYKkfRO6bgSU+h
	ynAsWUV2hG7AYPHWK8huGRjwuKGFww0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776070002;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5agqwrJT2AkhcCX6tI8RQWaticWktVRky7unduqbP58=;
	b=k/eGmCKTIf/+JW5VCdKBK8iwb2TpQ7FweWl5lf8TaL7wlKJF1pGYslVij2+QvOMfkuFi9f
	96PwGwKsvh+OJ0Bw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3JH9s5Uf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="k/eGmCKT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776070002; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5agqwrJT2AkhcCX6tI8RQWaticWktVRky7unduqbP58=;
	b=3JH9s5UfURzKVTl6JkyrKDL6Fj9s3sYm6bRkyrbQ6jONbBGSq2wYSokinRtQCmRNqWikSZ
	FsK3aL6TsShrp1ieISWoNir+3MD3AHMF0QS+DjKGRvcaRcDIKe3+r4dWwYKkfRO6bgSU+h
	ynAsWUV2hG7AYPHWK8huGRjwuKGFww0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776070002;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5agqwrJT2AkhcCX6tI8RQWaticWktVRky7unduqbP58=;
	b=k/eGmCKTIf/+JW5VCdKBK8iwb2TpQ7FweWl5lf8TaL7wlKJF1pGYslVij2+QvOMfkuFi9f
	96PwGwKsvh+OJ0Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E97C4ADCB;
	Mon, 13 Apr 2026 08:46:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3htaC3Kt3Gn8IQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Apr 2026 08:46:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E5C64A0AFF; Mon, 13 Apr 2026 10:46:37 +0200 (CEST)
Date: Mon, 13 Apr 2026 10:46:37 +0200
From: Jan Kara <jack@suse.cz>
To: Andres Freund <andres@anarazel.de>
Cc: Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <2hwc3ixfwvpnaazsm7y2vgrdh5em4fosxdcs2lhszcsn7mlcca@u3c5czxxcatv>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <s2dr4cedsmqby6e3ijauv5p55vrde7c4ldyk5gxdw5iku66rbc@x3nipjpgqjh2>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s2dr4cedsmqby6e3ijauv5p55vrde7c4ldyk5gxdw5iku66rbc@x3nipjpgqjh2>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLdm6atg3brhgkpf5edrhhu3tq)];
	MISSING_XM_UA(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3C37E6A891

On Fri 10-04-26 11:06:23, Andres Freund wrote:
> Hi,
> 
> On 2026-03-26 21:42:50 -0400, Zi Yan wrote:
> > Replace it with a check on the max folio order of the file's address space
> > mapping, making sure PMD_ORDER is supported.
> 
> Question from a user space developer (who learned of this via LWN [1]):
> 
> Right now MADV_COlLAPSE on file mappings appears to only only work with
> CONFIG_READ_ONLY_THP_FOR_FS.
> 
> That's pretty sad, because I see quite consistent gains (~15%) from doing
> madvise(MADV_COLLAPSE) on e.g. postgres' .text - but because
> CONFIG_READ_ONLY_THP_FOR_FS is not enabled default (or at least not commonly,
> I think?) in distro kernels, it never quite seemed worth the fiddliness.
> 
> 
> Do I understand correctly that by replacing the check here (and the
> predecessor commits), madvise(MADV_COLLAPSE) on file mappings might actually
> start working in more situations on typical distro kernels?

FWIW we soon might be creating PMD sized folios for executable VMAs by
default [1] (at least for archs with 4k page size). So there'd be no need
for explicit MADV_COLLAPSE to get the gain.

								Honza

[1] https://lore.kernel.org/all/20260402181326.3107102-3-usama.arif@linux.dev/

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
