Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=121.127.44.73
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793635449;
	b=Zhg8v1VyrQjTIk27dyLQbNrxjcBV1L/J0Xxyqy4az2u7gNkQQkf87I/PmqJV7+S8ZGPx
	 3cv7J74v3ZavcNcX5Q/LxnDP+aoAJW+f9/KjFm2vdiFE4BkhpxI2/eJPOKgkhnZOfQ5z2
	 0G1/Pz724d7rxNur/dfb0pMmplso36zrVxwjA+qNjm9sdymdzyuevJVhoUTZ+e3wCLJxB
	 V04sLvIvnwIL6Wl7EwmUahK5FZkI4fry7hTl0j8Etr6iq4FFXaoKybsgIbYFkaUff4qeo
	 HLOTKMNmeTe/NanW1d4B/reNlQTv78dJsl5hyJ45nGQDVR0dq6+V6F+zx9itvDjgBzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793635449;
	h=DMARC-Filter:DKIM-Signature:X-Forward-Email-ID:
	 X-Forward-Email-Sender:X-Forward-Email-Version:
	 X-Forward-Email-Website:X-Complaints-To:X-Report-Abuse:
	 X-Report-Abuse-To:From:To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=fgLhXCQu/PXVPpCeLvo3HZDhxIiX+1thUvLIpnhj0EE=;
	b=CNyqorR5UIJkq5WNMJKzr2yh1KgdNbe96sYxCJF7YMe2ZiYZBTbWwiHaQ/QnyR+7KYpF
	 6FJ3TNKWNnwRvoslvkv+Y333YezhH5qIPwQ+FeNYTKrG1r8iyEGh4WVZaNzT2gDkitBSb
	 B7FpCPOvth51Ay6fnMuI/0fzJsXU9Mnxnzaz29UysACPWGIHED6uZDcpxWGKPXHuXF6ey
	 U1NDKm70SQzIBvu1UqPHRxgySqweZhG7rzBvBRSZEm5EkIz40sdZyo9riP4Qt2tr8w52Y
	 y/zLCcCJPYMaI7VQ8tNOYy9Mi4o9FEGAMJZ4pcQW/OLlW09K5rhe29QT+BIkKKK7DDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alexs.space;
	spf=pass smtp.mailfrom=fe-bounces.alexs.space;
	dkim=pass header.d=alexs.space header.i=@alexs.space header.a=rsa-sha256 header.s=fe-034aa486fd header.b="ktv9d7/d";
	arc=none smtp.remote-ip=121.127.44.73
Received: from smtp.forwardemail.net (smtp.forwardemail.net [121.127.44.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D65606C553
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 16:04:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04D65606C553
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=alexs.space
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fe-bounces.alexs.space
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=alexs.space header.i=@alexs.space header.a=rsa-sha256 header.s=fe-034aa486fd header.b=ktv9d7/d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alexs.space;
 h=Content-Transfer-Encoding: Content-Type: MIME-Version: Message-ID: Date:
 Subject: To: From; q=dns/txt; s=fe-034aa486fd; t=1793635442;
 bh=fgLhXCQu/PXVPpCeLvo3HZDhxIiX+1thUvLIpnhj0EE=;
 b=ktv9d7/dpS9BI0QY++drh7K8FhbAO8uCabNYG5YsxcqXSMXNbCO0BQIbkQi5xxjOkOFyfBgl/
 fCNU7RNbtv+ZW+vDeUxdbiEaw1MIQVjR+p1glLqKbMFI8ZvnwZgkSi1daXLcUG/edFopVhUvZJj
 EVAV3C5/Y4wgNDiNdeXPnew=
X-Forward-Email-ID: 6ae8b46d28c70593327ea289
X-Forward-Email-Sender: rfc822; linuxkernel+co@alexs.space,
 smtp.forwardemail.net, 121.127.44.73
X-Forward-Email-Version: 2.18.13
X-Forward-Email-Website: https://forwardemail.net
X-Complaints-To: abuse@forwardemail.net
X-Report-Abuse: abuse@forwardemail.net
X-Report-Abuse-To: abuse@forwardemail.net
From: linuxkernel+co@alexs.space
To: linux-btrfs@vger.kernel.org
Subject: deleted subvolume isn't cleaned while an inotify watch is on its root
Date: Mon, 02 Nov 2026 09:43:58 +0000
Message-ID: <18e431317f832f21-26f56778@a-workstation>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

A subvolume deleted while something has an inotify watch on its root directory stays in "btrfs subvolume list -d" until the watch is removed. The watch never gets IN_DELETE_SELF or IN_IGNORED, so the watcher has no reason to drop it. Same with rmdir of an empty subvolume. I hit this with syncthing, which had watches on a few subvolumes inside a synced folder; they were only cleaned once syncthing let go.

To reproduce:

    truncate -s 512M /var/tmp/btrfs.img
    mkfs.btrfs -q /var/tmp/btrfs.img
    mkdir /var/tmp/t
    mount -o loop /var/tmp/btrfs.img /var/tmp/t
    btrfs subvolume create /var/tmp/t/sv
    inotifywait -m /var/tmp/t/sv &
    sleep 1
    btrfs subvolume delete /var/tmp/t/sv
    sleep 30; btrfs filesystem sync /var/tmp/t
    btrfs subvolume list -d /var/tmp/t
    kill %1
    sleep 5; btrfs filesystem sync /var/tmp/t
    btrfs subvolume list -d /var/tmp/t

Output on 7.3.0 (CachyOS build):

    Create subvolume '/var/tmp/t/sv'
    Setting up watches.
    Watches established.
    /var/tmp/t/sv/ OPEN,ISDIR 
    /var/tmp/t/sv/ CLOSE_NOWRITE,CLOSE,ISDIR 
    Delete subvolume 256 (no-commit): '/var/tmp/t/sv'
    ID 256 gen 9 top level 0 path DELETED

The first "list -d" is 30 seconds after the delete; the second, after killing inotifywait, prints nothing. Without the inotifywait the subvolume is cleaned right away.

It looks like btrfs_delete_subvolume() leaves i_nlink of the root inode at 1, so dentry_unlink_inode() never calls fsnotify_inoderemove(), and the mark keeps the inode, and with it the dead root, alive. kernfs had the same problem and fixed it in 7.1 by clearing i_nlink on removal (eea5d2bb34ba).

Thanks,
Alex

