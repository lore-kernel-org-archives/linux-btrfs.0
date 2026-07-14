Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7EA36A004
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 22:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784069652; cv=none; b=H+eNS+/5MzBMGsd2KKC/OuWT3upIuaj4hgTi2qelsyIRc+cdiR7U0THFYt5L8Mfae68dq2hZbr62Gh91v0kpNYXp3cah7BvwxCUoWTDA51JVoJoFYssHJWpWwI7AVLiVl2DJn07rRrcW92kqV+utVxWf2B4GM0n/+e18FcyTygA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784069652; c=relaxed/simple;
	bh=t8dsh5415XSw6Rfkwmff7zJ/jkGMxFjtUauKtMBsgak=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WN1IXkgveVsVClfTNnIAeNStuJ+5D7nFbc/d36iF+s2Fjav/gIeoj1S35d0FlU9KsvwR340QVYRbronydCERnX7fhWIoc5lsCA+LJ+jUom6r42mNu5yYOU8W3cb2nc0HfQ7fGbXnaJ6TfyCBb/Iw92XxOzFpP+rPp1W1IEvYEY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eodlWaIz; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VnR1dVIf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eodlWaIz";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VnR1dVIf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C6DD87808A
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 22:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784069649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=bCnrzbdU2KlNou00bClIP/GorQV/wWzKgmNfhunc2ac=;
	b=eodlWaIzQI4pp445A3GaAXcl+BnCwY0eApYP92OtXBYQlRKyxRsDX50fzc53ldZ+ZlhWCr
	5Xd+CExmaRriNx079eYp0KgikIXK+SrRN7GHlVtBlyjNZPCy4/kz9WQmkln7LiadUB2Cf6
	tiVt4N0AQFVkKVNEu7czlvaft+QynoA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784069647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=bCnrzbdU2KlNou00bClIP/GorQV/wWzKgmNfhunc2ac=;
	b=VnR1dVIfL9s560O8EszjTo2e+k9NHTfcQ7mWkbmMNjUu+a0HjiXkOcXH23hPiAvY2vQj8a
	em/lOFn/NgQDo7Q0GVj8xIDN7iqCuAg7X+svFiSxMk5q/vDRkA+CSdia42LylUjuzjGk7L
	jX9QR0u6GsnsHR+oGGSWwfgM59BnHlQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BAF7C779AE
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 22:54:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zto+LQ++VmogCAAAD6G6ig
	(envelope-from <dsterba@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 22:54:07 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 7.1
Date: Wed, 15 Jul 2026 00:54:04 +0200
Message-ID: <20260714225407.688358-1-dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,pypi.org:url,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

Hi,

btrfs-progs version 7.1 have been released.

Changelog:

* mkfs:
  * use GET_CSUMS ioctl (if provided by kernel, 7.2) to reuse existing
    checksums for --rootdir, works with --reflink to avoid reading file data
  * fix last block handling for reflink
  * fix handling of incompressible data extents
  * fix --rootdir size estimation when using hardlinks
* fi mkswapfile: add option to specify page size, useful on ARM64
* check: add option to skip qgroup verification to speed up check
* in experimental build, use V2 of tree search ioctl, this can use larger
  buffer
* preliminary fscrypt support
* enhance filesystem opening modes with more fine-grained support of
  partially damaged trees and allow to skip non-essential trees
* other:
  * stability and error handling fixes
  * CI updates
  * updated tests
  * documentation updates

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
Release: https://github.com/kdave/btrfs-progs/releases/tag/v7.1
Python: https://pypi.org/project/btrfsutil/
