Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFE342669A
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 15:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780931147; cv=none; b=dfy5CpKlUU6OvmaUVCDPv+60JvELUe7MCwJsFxdlCCXUaFZj9N4qG5fSSdLT1cf/jUH/sattnpba1Wub2t6vIPEScWL+Lp1vXxIYWTewpO/qfe6nxz73SbhqHXj2JnbcUYeD3swSRPLWLdA+yYLe6iOpQewJj61N19R/6FgUsAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780931147; c=relaxed/simple;
	bh=HU3GmUYujVH6vNcbGatgyNFYZcWLy7MFFWgsgYdycKw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lo8f9sMS3Mh+/kOFTYZKe7xw63B0evhM99d2YjksfzpO01S6XZmz6nd59S2duW5QuNkUrjwqm998fV3UNbARaZOcy3Dh/hHChxCFLEHbXjwYRtsBhQOP9DFyM1baCvH3edR57Y7S4YTSjf/7XrgE2WhY7AkhEC3ppijY9O2jADc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eOiJ/dIk; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eOiJ/dIk"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-9159da9bba5so316241485a.1
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jun 2026 08:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780931144; x=1781535944; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hSrv/WqedQ/svpxQS4o8+LnhZN2DNI+QJkuf2ID8DKc=;
        b=eOiJ/dIkZZDiBN1tbpHo82m5VZ3+ihtP898Gr2cFI33BpnXFx07wpwEy5eqxoAjF9e
         ISocTuvvA/54ndLV59MynBwvatPHvGZ3qfTsKaW2viBEqrlqRYqPyGAoP0TDt2ChOWYZ
         luPG8QuMoYlXk+Uzi0+vu2OaUOTYzazlA11UCDULt27FFynGGmQ9jIa825Zmd0dXxrdL
         hnEYPHT3d0JZjUOVVHiCttT7hTW4oHnntnP1pmoq6/zRzXVIQT5LV3F7/N208AxYxPCz
         gaKbNmsxYh7K8fm6MzI3ySfPWYcFngF6u1bjhNzHR6+89i4b4pguoTX8FVlIJJdbrKBc
         +Zxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780931144; x=1781535944;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hSrv/WqedQ/svpxQS4o8+LnhZN2DNI+QJkuf2ID8DKc=;
        b=dVMYuWO6YmcNs75JfidpJc87WLCwlOR0PMdjr1nJgV9hQa9g3Tg+9syjPTh5wwkEkX
         3MZRuc7x3WUhJqPM1aEKSfoqVkAaNsqczKZdOxDYdIwwXPN/JOkOjxwY04lIYa48ICQg
         6Yl5W8QCAFfxVVF37J2w2xrNgpafYkxZBWHDVSG8wBY2Jmo/kJuvRMceWLcwlSKYkn4a
         dnwWiJ8FtBEJIXMcb1Q3qUkaeKdY9mdpDvgct/Qyy1rp7c+HX3jN+oDJ4dPeqbDIPirB
         tApQWug/WZavVKtC+onIoHdSQvjpc4kdV4GloMhmzd/81aI1wuA7YD2luAApJJ0pRouK
         QZ9w==
X-Forwarded-Encrypted: i=1; AFNElJ8LmoaSWZJWQEYja19S6gWivzdGzbC6049FQjt1JBfMhey8HY7YsdSgkPuMruHceL3upu5AKD/xASrrkw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0kbkqwFi//Me/dAxIuJCR3Wrmlq+rX3e65loqPH9HMKk9Oo/f
	0b5NeM6/cyYAp99Gk4BFXWR2yb3UXNWgBzirylaEJQwl0wXLvOL6LVCi
X-Gm-Gg: Acq92OEC9U5Z4WnXtpj6NJg9GnnEShqegWI/902+BpPm7MBvtCMrEDANX3QAzzS/Ilw
	5p9g1Udi0JFwM7TMHUdL55lOSRFPwPsBXC1/rVGkCSSRX8VLdeTzCgBDnLWOsLLC8wI4lwa0Ooa
	WFTIMAO1F9yafZNhLqER9V8Z+6Li69d/nF184zhe+l7Yu6OJ/i5xbPK05TmuwJZyZPmduIpkn5m
	sAjg1z0y3+AC2rmDb2PE8iws1EW7V3tDIrePgruCcsaq1GYRDcbG8hU3QMt2GxwqlxJV2+LpJsB
	fnWVJRmqXyVfV8gXDAfchn+QAaDWsiR78C1Z0fR8doTUxr0T7E8GJNGBkSeWDF+bi/q9lZ3gmff
	MTg4+SrXPgK9dPZ7CcTZp+Py99A8UK9O8KBplf29HmP5rx1F1V1GeJLjlGOIipxWo5WRwraQLHO
	HLQ12TpCnitEEWMWN6TTGHcWYXdZJJcav8yNUkQoc=
X-Received: by 2002:a05:620a:414f:b0:915:776d:52f5 with SMTP id af79cd13be357-915a9c71fc7mr2606684485a.17.1780931143573;
        Mon, 08 Jun 2026 08:05:43 -0700 (PDT)
Received: from localhost ([43.225.189.113])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm1757032185a.22.2026.06.08.08.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 08:05:42 -0700 (PDT)
Date: Mon, 8 Jun 2026 18:05:36 +0300
From: Dan Carpenter <error27@gmail.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH next] btrfs: tracepoints: fix error code in
 add_conflicting_inode()
Message-ID: <aibaQGK38EIgqJQA@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

This code had a second "ret" variable that shadowed the "real ret
variable" so when we set the error code it was just discarded and
we returned success.  Get rid of the shadow variable.

Fixes: 3e4489a270f2 ("btrfs: tracepoints: add trace event for add_conflicting_inode()")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index bcccddcc568c..f01a53e825b0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6174,7 +6174,7 @@ static int add_conflicting_inode(struct btrfs_trans_handle *trans,
 	 *    some inode from it to some other directory).
 	 */
 	if (IS_ERR(inode)) {
-		int ret = PTR_ERR(inode);
+		ret = PTR_ERR(inode);
 
 		if (ret != -ENOENT)
 			goto out;
-- 
2.53.0

