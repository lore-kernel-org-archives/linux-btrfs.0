Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013055.outbound.protection.outlook.com [40.93.196.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F182347503;
	Mon, 23 Mar 2026 19:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774292838; cv=fail; b=Fd0G5KMka4KG7kJtxaUDClx9epqy73ZS1m9BhCr81LtWiIeEphasj2dXGD9BgO0rU25K32kI+1swd8B79rBM1Qyum3aIFOt/MRiC1peMPKFpq5OdRfpESNQZgYks55mKaP7tAv0eR5fTs31GblcrUQgzso3w9vcsB2ujk46CPnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774292838; c=relaxed/simple;
	bh=BpZca8bCgjwWJzRtTPus66o5RSKHiUTYOyT254Hz4BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UoCjc00C6A+jJIPMA0Q8hcAN4A9XAp33l1ZckRY/lHDvTarHOr77xoL3+kx+yaJ+SBL+45pTKdpenULDf7FytLERH1nCCMnUOUTvVhN+Y81kK52RD8NqbJ/eqKFe/rEEZv5eydXXr6oSt9Q52K3ETVcCCPiNArKib3rhfYT7wU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GufidYv+; arc=fail smtp.client-ip=40.93.196.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GufidYv+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MlcsRmgwgKJtgrwmQKWbaTJGRDiyPBua9JQ1e47XUM8k2HClGzkbbhI7QZCxQ/loXh1hlKpk+D/tmJF20hJajpWOifRZFunOYQfLDyODTa0fu0kZdn+74Otb+nchZUrrd6/jT5Lz6a++zO85v08DaL0evmEAtYDTm1MwttX4z8qBKJL8tyw2kZ7O2Dlw0dORHKWhuPFsZRviUyQ7IRM7ujsb2IwSQ0Ak24D3MLU3n+9cK/PgeK1UJE23FgFsgmkA3DpQ/OITviz8VcissT9pvlKConBq9p9BItU1xz1vcTWQxzNQLPgv1k79owRkouf4nm48bDyTj3HtSXPUfhpv4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yKXNE/HKJMx/bJ/qdkKaJVVdI2g0xgHu43iBYA3cQmI=;
 b=R+fLMgwFEM59pMqabBBp2Ye8oF2DUv8hrO0Tq7PrvOjvmthhNwnPREBl0BZy34UUnXfXgOl6FElI739KjdD/dhbB+rb5hU+mDTWLLoxHhi+BeCg/heWcxRNr33rVoCsw9KGYAqbbO0h+4Msg1IMpJyhXRpMvokA8yWOSfDcX8X3oik48WtdplXvoeUSKOSR+9g2ynMMWueflerZQejORDGV8UQhuS5LXbBrV3p47t9HZJD9vb7B356r3AQ3A7fgHf7uy7tQxaD/pzmhDKB29l/ExdCb61GViCZudLSHh9y78Lrk79wuyiAUjyUer02XpqUaCrZOOoTD9G3IHhIffyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKXNE/HKJMx/bJ/qdkKaJVVdI2g0xgHu43iBYA3cQmI=;
 b=GufidYv+ymdp11hBEuwrwSSkDxsMVL6dLLGiQmtli+J+uy0NDT9sclUcInK4VIcWNDPLUp2VfIO7JyzfnFC/tvgjDu3y9nNDofQLaxbb38ksuILmd0fDGO9SWsn95jIDndY05R4gJOA8rak7znRH9s3K4Xel97hp7XDWbBqi9u1vW5K0OprTCMYoqqZrFZ7/pAcv4bumsg4K6XBE1Ct2rNSJxj0qgyOT9/lgVCMoccAceVCztRLYJ3LRTp6Wiyn7usIiYGnxSN2onO1sUZiNI7gXAh95ZJpDGZ+/jCugtw3Z7s6zgEg33UhqAEbWkFtrocQYAqc14zb9WwmljZ9RTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Mon, 23 Mar 2026 19:07:04 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:07:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 11/11] selftests/mm: remove READ_ONLY_THP_FOR_FS test in guard-regions
Date: Mon, 23 Mar 2026 15:06:44 -0400
Message-ID: <20260323190644.1714379-12-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: 3221c15f-b54a-4678-bc5c-08de890f5ebd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0Ha8LUGxDRvmSiCLbN2Dmie1RvUCd2dSt0AGGGWR0Dbjb9ie/CnliE/eFTuIHO4Y5gml/qjMkPJd0CkasZgNILomG1Iq61eUIzi0TFZd2URsSx94dicCeYS24xm+3iniwsruSD/PBuPW8unw5a0QLxbtoSQCdVsd460XCHD6zX7KZSz5+LpW4Z7hsN9Ch+xHrt3xWpPuQgWouakqOd4Zg8i1VKCkb4rWtjrrsmMctUs9+60wCtWXldb3+CJavjizjkFjN1pfwDFofx2D7EQky30jHpQ69VOUprjcr2Q2bctzWGGx2n/zZerRn92V+kKN7ij2xn+OnVH0JmW4JGuqWNxAN5lMd0sAgbKlh1EGN821OL6Pt+McvpQzBq+rXdM+qHcU6eiu1ryfVRPjlb417CMc6/ZdcoLkZlltCzbn0nljIZaJzprt/CsPvBm5mhYWSs1nkM1/pXeuf40wlIvCCccdXNA8AQggrajWkDBeBRM3HYh3AmSwRoa0g6uHHqbp0bhMgCED7StxpVybA6Of9JRpAj+Tr82VMffF/gx5SBVKKD4A8BBmJ0SgcK97tgNHl0b6+yDh5KATnHCmSCT9H3kKLmhWsS+zXSFNw1p8pbGFieNjBefZzfasBWGeyj+TL/ym5VaXlKC1u23UugD0W/jeaxvv4dCKBsXitAfwdt1CDkBT+wmO+FFMb70aB2yQrYJFf2NOjWb6Lp4PwBb4CxTF29cbh1uINa4Q8QbT2HU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HuSkVY/AROSzfYJezdQs+OgHMV1bqtTq+KHcD4cMPORfi1JPnwE3n9/0jAQv?=
 =?us-ascii?Q?J1raPUIED2RsZS2Ql9tBQR/T9J09P6wcaCYWWbmrx0m6fj/2LEmgsVIOeS2B?=
 =?us-ascii?Q?drJzsHF/MZRwazs7ekS7Qc7ZGgysy+Mk69FFa5dEhy8oC2V38MFmRtNn9Ap6?=
 =?us-ascii?Q?hsbiM+FoOEezMwNkaTjnTet5iKr3rkjDBa/OjOKyEwODRzkP5AjRNw4T/AaU?=
 =?us-ascii?Q?lrpu37wqdPLFP3323zVpfDXrh6OxBX48SwKof4b5mAVe1j05liRZpUhToVjR?=
 =?us-ascii?Q?CspM+5a9XMPThzGzTwQ2tF5p0FaH397Q7QmouYaTOmsiryftDIDQcOOPcnnV?=
 =?us-ascii?Q?GuAknMRo+KEHE+ywL9ums3kETPD5SICGc/EeUap+VxnrraojVc3wJQLquSj+?=
 =?us-ascii?Q?31OAT4v8/ij1gURkDKM9RYK+IM+DDLEwGgbIAJqo69xc+OfAdPR5rgG7T9f2?=
 =?us-ascii?Q?7337hD+IAmcfx0VeHetIhC4XLRM2H4lyY1gNlablfxxKfwqqRRKZ7IOO1du+?=
 =?us-ascii?Q?Yrke+fMn1Oksd1trDSMWJxMHuxOJt7HyZEW97ggHJu26l34ZXIQtBwge/ib1?=
 =?us-ascii?Q?uEw4Ma+ZgLm49bgh6lTfGEdVqxyv9MICGR4cx+/yM/cU0yuBA9Ecm6KStQl0?=
 =?us-ascii?Q?e7t41eXpEOHCzNrA+8IDp8JCiusV/mi3s2xIekEfqm/I/3nbW/GmmfPcqwXd?=
 =?us-ascii?Q?C1EO3LBKP5PyGIE5EaNAgxGIKQBIUyHuF8/t8fwleNyDnHD9+22zuM5UIbbm?=
 =?us-ascii?Q?DV9hUi+uraZFv/suxiVZJRUUtjapt2iAb2cQPKELwTfoLg8MKZhzs81jgg3z?=
 =?us-ascii?Q?LP0eyClN46/h7zq3+rEg2LhLPBed/UjKSFgY07bdYhxqBvzmK94TCmRlKhog?=
 =?us-ascii?Q?qPkvAWs3UiE59eSTDWmsrWLajx3q2wOEMP1m9aplyiKKhaRhDnv5IP9Y3hX8?=
 =?us-ascii?Q?bABe822EMCDwGbOKcNVSu3jIyY6wov8ztmYIECseigopa96aWttuMVZNMYe6?=
 =?us-ascii?Q?f4jnAYGT3xVpL+QMot1LTT4ckN3C1o01SmiqLu0PypvO4e33H+c7dCxoVuUz?=
 =?us-ascii?Q?gPQ9cM0hHQhkwLbHmgD6RD4qIZEG9NbfAu6GQ3FeOOmpp/bdp9aJpZET7gci?=
 =?us-ascii?Q?xORoHuBvggn6N3s3TfmpBc2FtJCDpBg7fYjO2uDg0dg7BDfwjAhKRF4XwoTs?=
 =?us-ascii?Q?VKojniCF5mEdXIwyrK4J1qbJLEkxUzuPlRmZSSARjcSQ+W/jc7Z5hCqucXOZ?=
 =?us-ascii?Q?AdhHUVeuC74ojdiah+mkWPt2dTd1v7fhP1BS2F869CRAyyN0SjAvuw+veqOf?=
 =?us-ascii?Q?p14+55WFwQjqOhRvyS75q/J7hDePsFcbDe0vz8iYvsDDXlBusL9IJ8Bydahk?=
 =?us-ascii?Q?4TDtQhSr3S2EHKZq1STttlNzrUqIJXYgQEu9yAuzgp9dgOhxt0DP6XCd83E4?=
 =?us-ascii?Q?Jz8Fu2zuPjSKgwTUvjlR4q7ZUnRnxpMZpUSv9AEmLp04QZd95d1MWzZPVSFf?=
 =?us-ascii?Q?+X0GpfJFYhAE5Jvk3Q4/nK9VjnCdscFRDG9ho1Sxln+XPHE3yIlpAtIVqccB?=
 =?us-ascii?Q?7wwsWxxRQ3coBBSZFmVJuko3YEoTknPPnUktZTa61LyM8jqTctKePsHy/rFq?=
 =?us-ascii?Q?rfde+5xSdPs/XPre1v4Wnqj5H8lIc/NXPVrPmPiaM4fWoNL0DmUukWEGgIHm?=
 =?us-ascii?Q?+8AB1RMGMGPMLXo8Ovv3Yw1SvroDi2KAcQY+JDLioiOAK30k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3221c15f-b54a-4678-bc5c-08de890f5ebd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:07:04.1541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GgloJhvqcENDWV3AdfjXn99pjdSSvlucji4tfGk/Qw6cuoQ2V76PyDC+GxlYYp4G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607

READ_ONLY_THP_FOR_FS is no longer present, remove related test.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/guard-regions.c | 148 +--------------------
 1 file changed, 1 insertion(+), 147 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 48e8b1539be3..fc8b2a4e7ba2 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -42,7 +42,6 @@ static sigjmp_buf signal_jmp_buf;
 enum backing_type {
 	ANON_BACKED,
 	SHMEM_BACKED,
-	LOCAL_FILE_BACKED,
 };
 
 FIXTURE(guard_regions)
@@ -67,11 +66,6 @@ FIXTURE_VARIANT_ADD(guard_regions, shmem)
 	.backing = SHMEM_BACKED,
 };
 
-FIXTURE_VARIANT_ADD(guard_regions, file)
-{
-	.backing = LOCAL_FILE_BACKED,
-};
-
 static bool is_anon_backed(const FIXTURE_VARIANT(guard_regions) * variant)
 {
 	switch (variant->backing) {
@@ -98,7 +92,6 @@ static void *mmap_(FIXTURE_DATA(guard_regions) * self,
 		offset = 0;
 		break;
 	case SHMEM_BACKED:
-	case LOCAL_FILE_BACKED:
 		flags |= MAP_SHARED;
 		fd = self->fd;
 		break;
@@ -198,18 +191,6 @@ static void teardown_sighandler(void)
 	sigaction(SIGSEGV, &act, NULL);
 }
 
-static int open_file(const char *prefix, char *path)
-{
-	int fd;
-
-	snprintf(path, PATH_MAX, "%sguard_regions_test_file_XXXXXX", prefix);
-	fd = mkstemp(path);
-	if (fd < 0)
-		ksft_exit_fail_perror("mkstemp");
-
-	return fd;
-}
-
 /* Establish a varying pattern in a buffer. */
 static void set_pattern(char *ptr, size_t num_pages, size_t page_size)
 {
@@ -262,54 +243,6 @@ static bool is_buf_eq(char *buf, size_t size, char chr)
 	return true;
 }
 
-/*
- * Some file systems have issues with merging due to changing merge-sensitive
- * parameters in the .mmap callback, and prior to .mmap_prepare being
- * implemented everywhere this will now result in an unexpected failure to
- * merge (e.g. - overlayfs).
- *
- * Perform a simple test to see if the local file system suffers from this, if
- * it does then we can skip test logic that assumes local file system merging is
- * sane.
- */
-static bool local_fs_has_sane_mmap(FIXTURE_DATA(guard_regions) * self,
-				   const FIXTURE_VARIANT(guard_regions) * variant)
-{
-	const unsigned long page_size = self->page_size;
-	char *ptr, *ptr2;
-	struct procmap_fd procmap;
-
-	if (variant->backing != LOCAL_FILE_BACKED)
-		return true;
-
-	/* Map 10 pages. */
-	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
-	if (ptr == MAP_FAILED)
-		return false;
-	/* Unmap the middle. */
-	munmap(&ptr[5 * page_size], page_size);
-
-	/* Map again. */
-	ptr2 = mmap_(self, variant, &ptr[5 * page_size], page_size, PROT_READ | PROT_WRITE,
-		     MAP_FIXED, 5 * page_size);
-
-	if (ptr2 == MAP_FAILED)
-		return false;
-
-	/* Now make sure they all merged. */
-	if (open_self_procmap(&procmap) != 0)
-		return false;
-	if (!find_vma_procmap(&procmap, ptr))
-		return false;
-	if (procmap.query.vma_start != (unsigned long)ptr)
-		return false;
-	if (procmap.query.vma_end != (unsigned long)ptr + 10 * page_size)
-		return false;
-	close_procmap(&procmap);
-
-	return true;
-}
-
 FIXTURE_SETUP(guard_regions)
 {
 	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
@@ -318,9 +251,6 @@ FIXTURE_SETUP(guard_regions)
 	switch (variant->backing) {
 	case ANON_BACKED:
 		return;
-	case LOCAL_FILE_BACKED:
-		self->fd = open_file("", self->path);
-		break;
 	case SHMEM_BACKED:
 		self->fd = memfd_create(self->path, 0);
 		break;
@@ -1750,55 +1680,6 @@ TEST_F(guard_regions, map_private)
 	ASSERT_EQ(munmap(ptr_private, 10 * page_size), 0);
 }
 
-/* Test that guard regions established over a read-only mapping function correctly. */
-TEST_F(guard_regions, readonly_file)
-{
-	const unsigned long page_size = self->page_size;
-	char *ptr;
-	int i;
-
-	if (variant->backing != LOCAL_FILE_BACKED)
-		SKIP(return, "Read-only test specific to file-backed");
-
-	/* Map shared so we can populate with pattern, populate it, unmap. */
-	ptr = mmap_(self, variant, NULL, 10 * page_size,
-		    PROT_READ | PROT_WRITE, 0, 0);
-	ASSERT_NE(ptr, MAP_FAILED);
-	set_pattern(ptr, 10, page_size);
-	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
-	/* Close the fd so we can re-open read-only. */
-	ASSERT_EQ(close(self->fd), 0);
-
-	/* Re-open read-only. */
-	self->fd = open(self->path, O_RDONLY);
-	ASSERT_NE(self->fd, -1);
-	/* Re-map read-only. */
-	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ, 0, 0);
-	ASSERT_NE(ptr, MAP_FAILED);
-
-	/* Mark every other page guarded. */
-	for (i = 0; i < 10; i += 2) {
-		char *ptr_pg = &ptr[i * page_size];
-
-		ASSERT_EQ(madvise(ptr_pg, page_size, MADV_GUARD_INSTALL), 0);
-	}
-
-	/* Assert that the guard regions are in place.*/
-	for (i = 0; i < 10; i++) {
-		char *ptr_pg = &ptr[i * page_size];
-
-		ASSERT_EQ(try_read_buf(ptr_pg), i % 2 != 0);
-	}
-
-	/* Remove guard regions. */
-	ASSERT_EQ(madvise(ptr, 10 * page_size, MADV_GUARD_REMOVE), 0);
-
-	/* Ensure the data is as expected. */
-	ASSERT_TRUE(check_pattern(ptr, 10, page_size));
-
-	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
-}
-
 TEST_F(guard_regions, fault_around)
 {
 	const unsigned long page_size = self->page_size;
@@ -2203,17 +2084,6 @@ TEST_F(guard_regions, collapse)
 	if (variant->backing != ANON_BACKED)
 		ASSERT_EQ(ftruncate(self->fd, size), 0);
 
-	/*
-	 * We must close and re-open local-file backed as read-only for
-	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
-	 */
-	if (variant->backing == LOCAL_FILE_BACKED) {
-		ASSERT_EQ(close(self->fd), 0);
-
-		self->fd = open(self->path, O_RDONLY);
-		ASSERT_GE(self->fd, 0);
-	}
-
 	ptr = mmap_(self, variant, NULL, size, PROT_READ, 0, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
@@ -2234,13 +2104,7 @@ TEST_F(guard_regions, collapse)
 	/* Allow huge page throughout region. */
 	ASSERT_EQ(madvise(ptr, size, MADV_HUGEPAGE), 0);
 
-	/*
-	 * Now collapse the entire region. This should fail in all cases.
-	 *
-	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
-	 * not set for the local file case, but we can't differentiate whether
-	 * this occurred or if the collapse was rightly rejected.
-	 */
+	/* Now collapse the entire region. This should fail in all cases. */
 	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
 
 	/*
@@ -2298,16 +2162,6 @@ TEST_F(guard_regions, smaps)
 	ASSERT_TRUE(check_vmflag_guard(ptr));
 	ASSERT_TRUE(check_vmflag_guard(&ptr[5 * page_size]));
 
-	/*
-	 * If the local file system is unable to merge VMAs due to having
-	 * unusual characteristics, there is no point in asserting merge
-	 * behaviour.
-	 */
-	if (!local_fs_has_sane_mmap(self, variant)) {
-		TH_LOG("local filesystem does not support sane merging skipping merge test");
-		return;
-	}
-
 	/* Map a fresh VMA between the two split VMAs. */
 	ptr2 = mmap_(self, variant, &ptr[4 * page_size], page_size,
 		     PROT_READ | PROT_WRITE, MAP_FIXED, 4 * page_size);
-- 
2.43.0

