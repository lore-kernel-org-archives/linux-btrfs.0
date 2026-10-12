Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED9F368299;
	Mon, 12 Oct 2026 13:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811816; cv=none; b=TUr8QlemsTr1VbM/3RXhhRMgvx+Ugb3WYSIYY/idkItO2BI0YdTaNHtIgoc9+/OPUZVuPphm94mRI3lIRrgatrVTxHlfEY6crrtNkt6BtFBI+KOVq3YvFPydYsiDiJumo05nR0RrkSs6KGzrRQJ5bfgM47le4IFui+/ZTEpYidQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811816; c=relaxed/simple;
	bh=FywYCWSfiY9ms9C9PLbE8ARJtBQ6YSn2sK3jwRHqYlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMLYWP4iFEMG8Un6w3tySnD3Hxug4PyfmWijkv4Zfw7Hh9ORyRpZBdadpfmoLaIWpQcbxQD68UYtLdzs6Kua4Pb5LXDkjeC07PLzpt/3BJQErrnWdqLM8wYdk1rfy9un2WMMzOAn7dzUrtjCB+EjZ8LlAFEk7/bwhZXnMJpG6aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=M3Wc34Mm; arc=none smtp.client-ip=220.197.31.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="M3Wc34Mm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=AO
	+FJNZGu61PV+EG9aVDTlV2Mgmta7rVFhMGE/afT/w=; b=M3Wc34MmcbFqduv8lR
	gJliMrYPas/0ox77rilcQWJC1RaGkESTnPiKv733vfsm7ubGGh70ne3cqp+xzpjS
	XOhgxpjw7TyjBy/a6CN9cSNTIrPrwDhMcOVE3Au+rxlxNo41P6dDE30/wViNT05L
	7BQEECk3/AoU5woHTeDzGrt2c=
Received: from song-MS-7E28.. (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3n7am4MxqMdzZBA--.33230S3;
	Mon, 12 Oct 2026 21:29:15 +0800 (CST)
From: Song Chen <chensong_2000@126.com>
To: dsterba@suse.com,
	mason@kernel.org,
	akinobu.mita@gmail.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	arnd@arndb.de,
	akpm@linux-foundation.org,
	ees@kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Chen <chensong_2000@126.com>
Subject: [PATCH v3 1/2] error-injection: Introduce EI_ETYPE_FALSE for fail_function
Date: Tue, 13 Oct 2026 05:29:09 +0800
Message-ID: <20261012212910.54623-2-chensong_2000@126.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012212910.54623-1-chensong_2000@126.com>
References: <20261012212910.54623-1-chensong_2000@126.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n7am4MxqMdzZBA--.33230S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw45uFy3ZrykXw4ktF4xWFg_yoW5JFWfpF
	yDCr9rWry0gw18CrWxAFWxAryY9rsrWrWUKFn8Gws7Zw42vFWktwsYgryUX3s5GrW8CayU
	Xa97WFsYyw4jyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jKsj8UUUUU=
X-CM-SenderInfo: xfkh02prqjsjqqqqqiyswou0bp/xtbBswwxsGrM4KyaXAAA3S

Introduce EI_ETYPE_FALSE for functions which need false as return
value in their error-injections, like btrfs_data_csum_ok.

EI_ETYPE_NULL can return 0 too but its readability is not good
enough.

Acked-by: David Sterba  <dsterba@suse.com>
Signed-off-by: Song Chen <chensong_2000@126.com>
---
 Documentation/fault-injection/fault-injection.rst | 3 +++
 include/asm-generic/error-injection.h             | 1 +
 kernel/fail_function.c                            | 2 ++
 lib/error-inject.c                                | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/Documentation/fault-injection/fault-injection.rst b/Documentation/fault-injection/fault-injection.rst
index c2d3996b5b40..86431ad2b565 100644
--- a/Documentation/fault-injection/fault-injection.rst
+++ b/Documentation/fault-injection/fault-injection.rst
@@ -347,6 +347,9 @@ EI_ETYPE_ERRNO_NULL
 EI_ETYPE_TRUE
   This function will return `true` (non-zero positive value) if it fails.
 
+EI_ETYPE_FALSE
+  This function will return `false` if it fails.
+
 If you specifies a wrong type, for example, EI_TYPE_ERRNO for the function
 which returns an allocated object, it may cause a problem because the returned
 value is not an object address and the caller can not access to the address.
diff --git a/include/asm-generic/error-injection.h b/include/asm-generic/error-injection.h
index b05253f68eaa..6c399121ab7a 100644
--- a/include/asm-generic/error-injection.h
+++ b/include/asm-generic/error-injection.h
@@ -8,6 +8,7 @@ enum {
 	EI_ETYPE_ERRNO,		/* Return -ERRNO if failure */
 	EI_ETYPE_ERRNO_NULL,	/* Return -ERRNO or NULL if failure */
 	EI_ETYPE_TRUE,		/* Return true if failure */
+	EI_ETYPE_FALSE,		/* Return false if failure */
 };
 
 struct error_injection_entry {
diff --git a/kernel/fail_function.c b/kernel/fail_function.c
index 2eaf55005f49..90cdad0412cd 100644
--- a/kernel/fail_function.c
+++ b/kernel/fail_function.c
@@ -48,6 +48,8 @@ static unsigned long adjust_error_retval(unsigned long addr, unsigned long retv)
 		break;
 	case EI_ETYPE_TRUE:
 		return 1;
+	case EI_ETYPE_FALSE:
+		return 0;
 	}
 
 	return retv;
diff --git a/lib/error-inject.c b/lib/error-inject.c
index 32f3d1ca9ea2..115b10dbf9aa 100644
--- a/lib/error-inject.c
+++ b/lib/error-inject.c
@@ -189,6 +189,8 @@ static const char *error_type_string(int etype)
 		return "ERRNO_NULL";
 	case EI_ETYPE_TRUE:
 		return "TRUE";
+	case EI_ETYPE_FALSE:
+		return "FALSE";
 	default:
 		return "(unknown)";
 	}
-- 
2.43.0

