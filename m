Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793210151;
	b=cgnzjEchJD2nji0pcunohMYhwnbiYa9AlCrPbYLcMja2cjdqAQ0le8dTtz32CzP70IrH
	 bq/7xjmgQFJvjtKHE+xOwRuEvL3eoyEI6JqNFgA1tHec+Z79QtH4oQ9D3s8dDMhGu5a4e
	 i0aOjkPemFPKJTaY46+RfXKGuIQ+zYeUEWDq+jTYAjAAeU/WI8dB8+AKMEdgyhdwIgBDS
	 QwnBGBPysQZjFn3JYCdzoOiUnqu+roQEtVWqA4+stIt/tIPQ3E8uwycy5890++RNKaYWE
	 16vgnRuu8Xqlf6Z+xKBbmu97bMJt1JHjsU3VzvT7/9OuYt/Rin4RnPGW47tvLlIb5+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210151;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=rG5HB4Vnp00eGJo61jUBKAU/ra9VKyOht09dVZrL3So=;
	b=vvQR99q4Jf5P03ohMCZeYyhxdTgdDfztFi6JqL9jilHeFJYwXoe4Dl0/YQu0WYq1k1O9
	 P7R7Z7SMrB24xh8pjx9/5jOULMT7Pfj5CQObubfRJjHwOcIb48K67Usiezghlok04Dlbk
	 a8K+Un9DxZY6yQs+DBRPqMGX3LO2f9OlWwXGE/3ZkvpQC3K31F4zda0+a4r+LSO194Alv
	 sfiChvAA2Bu2E19PBhWCcOJa4ZCxs7W7v/PKD4CQqj8DdsG4FUvCQs7KU4lWUivbgL55f
	 kLbE+Feoy0XZ98uXC4LGvCVtHSFquaG2np35s0sqGetBr3xNZk4Ujc5dFUQlQ0QaP/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="U/nG83c/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F97606A31A;
	Wed, 28 Oct 2026 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U/nG83c/
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793210151;
	b=IzR5RpRbQiiMrAJ+pgzkhc63nOa61vqw6mN6nKg17284AHZAvR3FrnEpXtRTwiAP47El
	 PLjgUWTm5VzwqDdgXy9krJrPbDM505oDim0K8wIia9Gn8pFzXRBZVQC8Qz4jdGuNdIYSR
	 l0eBYqimowxTCj8GMeVvtPKgMHpiF93lvZYg/rN29RNR/SRjxeVhOhw6r+0pV/I61SSDp
	 2km0HMa1vqHqCMMz8qqqaT31YqpZUNCxdJ0lqRigZnw4/G3/JYBKjSzdNmVgXObDnAZpf
	 c3BjSFMEBmJxDEbML5Jvxb+0vDne4hBLVjOlXEnHHWKqqL/AnkOamwATGbjgDFjTm7g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793210151;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=rG5HB4Vnp00eGJo61jUBKAU/ra9VKyOht09dVZrL3So=;
	b=PvnURWxxxhOZDMiknE3l2aCXAyQU+NOvgkxlDdOpjWN2/9PzWMCKYKwepqEVoq40Pu/a
	 Mqa/3013666NKZNGG/X9kGIUT7K4MOdLthIOxFq8GO+fc4p0nQLlbUc2OTAuyWPbatQkp
	 nP1c0DWoKb46rvL3p7VrqdTrLY6uZl1wBJx+4n4fbE6bmXSb2ElBruIIO+9vSnLrPaQVm
	 ohkHqP7TDYQlvaNutF3n9mbenoGc+q8dNEx4u/8LfHMlNehP9L7yudGH97XmhP/gNcnFQ
	 oWh/OiDv3PmFAb9Dbbog+OyLWipglXOz0NSdnbAlYafY0nZ4cmyCIC1DCCG9HPr5yKw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C249A1F01828;
	Wed, 28 Oct 2026 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793210151;
	bh=rG5HB4Vnp00eGJo61jUBKAU/ra9VKyOht09dVZrL3So=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=U/nG83c/uWI+0EBdiDZZx8xwAE3WGY/QXwQggx1N88xs39leVTv69vJs5AxxxguAZ
	 BVVdB0nNwqj4dJQnTHbIeVrsN/+8RXb5IOZk4HtqGkEJTOWZRWI+r2WVwxJ9o+bMzl
	 4ns8NTvXcQzpAlxfQXakG3HPGqtx+e5WZ5kgOCllBPT+8/tnS/FP1o41Sz+asZd0Kq
	 gFhRxCrhkzhJDFfsXKMj6TR14O+VbtNPGG7iJQozwwlJ4SGmWtu6xLrvTQtATUHw2Z
	 kURYANEtBKuFcl1tlpmBC3K5Hh71SjKli/FI2Qo/GrboNoGDefZnSERci4Gzeu6JM0
	 F0qtztISKGriA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 532A645523;
	Wed, 28 Oct 2026 17:55:50 +0000 (UTC)
From: Luca Stefani via B4 Relay <devnull+luca.stefani.ge1.gmail.com@kernel.org>
Subject: [PATCH 0/2] btrfs: don't expose ERESTARTSYS to userspace
Date: Wed, 28 Oct 2026 18:55:48 +0100
Message-Id: <20261028-b4-btrfs-fitrim-interruption-v1-0-bf5c53738b3a@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/1WNwQrCMBBEf6Xs2cUkVA3+inhI0o1dwbRsUimU/
 ruJnjy+YebNBpmEKcO120DozZmnVEEfOgijSw9CHiqDUeaslbHoe/RFYsbIRfiFnAqJLHOpQ+y
 to8vJKh2dgqqYhSKvX/3t/uO8+CeF0pyt4V0m9OJSGFsUpoHW499Ba8C+fwD6eobCqgAAAA==
X-Change-ID: 20261028-b4-btrfs-fitrim-interruption-48ae75801fa0
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Luca Stefani <luca.stefani.ge1@gmail.com>
Cc: Robbie Ko <robbieko@synology.com>, Filipe Manana <fdmanana@suse.com>, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zhiwei Liang <zhiwei.liang@zliang.me>, Qu Wenruo <wqu@suse.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793210149; l=774;
 i=luca.stefani.ge1@gmail.com; s=20261028; h=from:subject:message-id;
 bh=LP4DYsLlDaDdL3BoYv5vWPMKYJ6s1RRwL4P6KPDAzyQ=;
 b=uIUbdgWZ2fNLrejSX67UdUxqI1ETM6ecJqN4cAjl7NEPosiANqjvj85RUUh0BRBtDgpo9orL2
 allb0rgwTrPDbujmi1NtLaPeza3YnHEno2ybDI1XYTb4fsRsDDDnXbk
X-Developer-Key: i=luca.stefani.ge1@gmail.com; a=ed25519;
 pk=0OIKU9oiaC0ALN4kqvw7ZbPFXqsBLvWm7MhEDYv3PyI=
X-Endpoint-Received: by B4 Relay for luca.stefani.ge1@gmail.com/20261028
 with auth_id=1347
X-Original-From: Luca Stefani <luca.stefani.ge1@gmail.com>
Reply-To: luca.stefani.ge1@gmail.com

trim can expose -ERESTARTSYS when the trim loops gets interrupted by
a freezer request.

Preserve byte counts of partially completed discards.
Consume cancellation at btrfs_trim_fs(), and report partial progress.

Link: https://lore.kernel.org/20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me/
---
Luca Stefani (2):
      btrfs: account partially completed discards
      btrfs: don't report failure when trim is interrupted

 fs/btrfs/extent-tree.c      | 10 ++++------
 fs/btrfs/free-space-cache.c |  5 ++---
 2 files changed, 6 insertions(+), 9 deletions(-)
---
base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
change-id: 20261028-b4-btrfs-fitrim-interruption-48ae75801fa0

Best regards,
--  
Luca Stefani <luca.stefani.ge1@gmail.com>


