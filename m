Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1660D37F741;
	Fri, 14 Aug 2026 08:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786696316; cv=none; b=cgeewfpLouiNwmhJdPA82Wqu//RQB/Br+HqbFJoKYTk3VkCeEkbsGkw3yaZ9dPEhPq7uc/IvEDRjFRoRUmtaLc24v4qgHVi40096/kKsThp2tSMaBjC7zitfYti2Bv/tI0Qdgk2iE5MKT/2mqk/+J1tcUDPO4WCz6dgJ2KSy52o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786696316; c=relaxed/simple;
	bh=xKcF41yHCZsQt4KHxjoO4vDOl8mu+S3V+uV6+LKhFRY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qagK0vhiphhr0OrDN4zJn1oxqnm4pQSgO/cRBgEaTwSWK6xzw4mOBtq4I6hJZvnmX6Ce5RmsGjEihyi2Gee7kMlBMVvgXFMchtmShEUuZUeznnMewux7Z3rA5y6rWpHZC7A/C62JB4UGMsx4buIxh5EZ0FDQV1g0NFzQDrPvAcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZDjm/QI5; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZDjm/QI5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=uP
	We5+dfRLqTKKLSZfG39MrfmdbzyW4D0JKzpWEgbh4=; b=ZDjm/QI5P4CLoa/8hZ
	+tiG4OmfgD/fBBbY66hErCscxxsE3EO85GRkt5JdzYy521Fa43jOgpGD3vn1thPh
	KLiU98hbXp2y+GlVoFTx/F8xJbVpGnZMfBx1y42Uic3LGDH8CwcCFo6hY05tHKSj
	sHEKO1o629YgryW2b6mm49zk4=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wDn4e1J0n5qDZryBQ--.22503S2;
	Fri, 14 Aug 2026 16:31:07 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: yangxiuwei@kylinos.cn
Cc: clm@fb.com,
	dsterba@suse.com,
	akpm@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	maharmstone@fb.com,
	quwenruo.btrfs@gmx.com,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v2 0/7] btrfs: fix io_uring encoded IO cleanup and compat
Date: Fri, 14 Aug 2026 16:31:05 +0800
Message-Id: <20260814083105.253101-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260806085041.1410576-1-yangxiuwei@kylinos.cn>
References: <20260806085041.1410576-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDn4e1J0n5qDZryBQ--.22503S2
X-Coremail-Antispam: 1Uf129KBjvdXoW5KF4UXrW3KrWkWFyrtF1xGrg_yoWxWFXE9r
	Z7Kw4j9w48JF17JayUKrWSvrZ8KasrCr1UJws5uFy7J3s3XFZrXFZYv34xJw1Yya9a9rn0
	vr1FqFsFqw1fKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREOJ5DUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgsBkWp+0kuVBAAA3F

On Thu, Aug 06, 2026 at 04:50:34PM +0800, Yang Xiuwei wrote:
> 3. SQPOLL / io-wq leave in_compat_syscall() false; export
>    __import_iovec() and pass IO_URING_F_COMPAT for the iovec import.

I retested with a 32-bit process on x86_64. Encoded ioctl and uring
IO both work, including when import runs on iou-wrk.

That claim was wrong for the usual same-process case. io-wq / SQPOLL
threads are created via create_io_thread() while the creator is still
in the compat syscall, so TS_COMPAT is copied into the new task and
import_iovec() already sees compat iovecs.

I will drop 3/7 and 4/7 in v3. The other cleanup patches stay.

Thanks,
Yang Xiuwei

