Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013048.outbound.protection.outlook.com [40.93.201.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA87382289;
	Wed, 29 Apr 2026 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477031; cv=fail; b=rCIVBhEUpokVfqTm4j8MeqTlonpIN3YMdlo9H0RqbIdZqH4RuQfuyWR+V0q0rrRHkP0DK8igIWxcmPRi7KJxT5PJhmucG8ZsTcG4SiyOSnqwpzSzJr+tFe6NCBepG3XcLwy64mA2l30D+NCugruf7j9B3iloD1dsMqdVvnbFxTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477031; c=relaxed/simple;
	bh=U1oR9wU98oORXXMDL8JNsLoIP8g++MhA/UbrdIbWDGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y1OazaVjrEBaOn9ZTfZ2+P9ICxgq773JoXrUlKVYyEcak+Gjk4NZp+yhMMKj6fTZDSebiZopmUU2FHU37y0aUD6KfolRxCZbFUKzebk/c2JTp8rpJvf0l0ThPnWwXuKABiWaLHV5fOblpgvnP+QmDNhFrmB12xj+n8JqAjiCUnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c8EJXeL/; arc=fail smtp.client-ip=40.93.201.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c8EJXeL/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MG9zUoH+FLXskB9EROON26Ac7lApdk9WtOo4ekoQXJ3yq5b05t/XSETE92q/0b/Ab1RNPSv83S1c4on9NjUBHqZeiklUNC8LhpKJ954lOGL9Z2gVgK9dHu4+dA+cH67aZrwy5H9zIo43V52o79QvEGXUXbqDDKIcjCEoD316QerTBjxCdGG/Ma00cMWMP4skqdoCcLWTY5dCfGlMcx7zpAnLbDi2Eq1/bmEq0V9/QftvpQFPSfAw3LwNVWz+OttrLdRRlX1UF9wFPt+YHoLhbRwYoqGVMw72ZFzq/iGa8259xAf0LVEt7hj75WgF8/l3m/grJqcJZd9OuWtATNqGjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egSVThUdiW76EbZbteJL7tr3CCcxnjihDEY0AyATk04=;
 b=XsCHCb8J7GihO1dc0OiOTV7Cvdao7SpAUz1KXwQHiNxBCNF/nMMdBtA0JneGTCGjsrMqzkbk47g1zcDsUKgEoAlKlONISkokQW6+RN/515WAwaaZ8Xm4ZW4hyie5qOkSTVri6otnots7xU/WmRaowJD9UtBh+yg3GDkqfpqMswTSiheK+J/sx6Lwasu0s5U3aKjqKwK4CqR4hqy+xHihucNJIOb2+bhUtXVeNKKVR01Yj3E+VFEsOJmpvC45vGr+EFlKxNVcR7ZWKZ06B5lhHtfsupNRJVfIn93duBPXdlKQVrnwvL2V0yNIRj+H3DgiqxJvqpGB6/swbnRHgiAIaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egSVThUdiW76EbZbteJL7tr3CCcxnjihDEY0AyATk04=;
 b=c8EJXeL/pjjcKX5YbfGUN8AYG975K03obIcqzUw7iHjpo5obYVMFOGGlWwPjDjXPlE5imFCoHWRwrGktMyOHlFLqXUpUpn2l6DTtbIXOriJ0pHMPHKPmMIW0y+JOVUyf58DCJSTC5zorN4mIDbZ8vR751xRnkuBtj9ggTmc/1IOEZDH93pcC97+wF9bXFN7bn4QgJ9DAZFHlnYzp5BQGhM3BBz6tL3p8GJ9ZuWpiKzenRobkzzoUsbKQCJ4QD+1aVVeYPW2pDWLRaSnQHKxvsTWv409mc0PEkshZwPeaa9SV76N+D4CcTvgKXs3aHRlh84i0BLSnoSQJOb+x+MIX6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8881.namprd12.prod.outlook.com (2603:10b6:a03:546::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Wed, 29 Apr
 2026 15:36:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:36:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
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
Subject: [PATCH v5 13/14] mm/khugepaged: enable clean pagecache folio collapse for writable files
Date: Wed, 29 Apr 2026 11:35:36 -0400
Message-ID: <20260429153538.727855-9-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0804.namprd03.prod.outlook.com
 (2603:10b6:408:13f::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8881:EE_
X-MS-Office365-Filtering-Correlation-Id: 96f72ef2-8c18-42d0-5197-08dea6052499
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cpfmSAbML2I0FHJtZHpNt/7mZhVPhHPz/O/zFIXm7Omgqc0oX+8dPGstKTGVrcrBW7Mh6jbQjOyrOsWJOV0+e8Ub7f4JD9slJD5d4MyrpFSb0ghJhxb0qZhgE822QuHEy6P9GouzGKOA9mUgXYLg0FjYAKF8ujlS++o11N5gulRWSNhUViv7RhWhUzl6h8sG01tn0gYqTXGaHG0EICp5X6Ja56Pq8upT2hOth3mWApKdWHD8PtZG5ZpQE33EBE2Lr84JH5o/XslQkheKVCOpNCYxQod+CnA+5FSbFMgBhSE7VjfPR7OAaiKCwK+jTQX+ZgFQ4XhBnvXTaV+3KNb2ykMbne6bWK9joMkVrVrUZz72cN6qrqxl/OPlqc1WAs6aGShAZlElIcJs2etghcdXSmXq/bFyOXVhchAUMnFdXCEE3QH/W//Ti9H1Ql0+2cwq6d9dtCIadeSa0MbaN2XM7hkR/JheXmvb6QT+BmGUmRPNtrPhgeYpUovZBxrK645CzOcBjA4F5aFS9aZUFjYbz6vMry6XBLvZL+GOSOEb8RF6BEtiNqwZQ+kxtMcdLnWkxW2ZwRE0Jd92RAETG/hhPy25+J/RAZCP2aINrxwb0iotj2wNN7RuQqni2Ac807+7f3B5uGbON1RS87KctFqDex6o53IbDgLGdRswEErg+5TWc6tEHADsVRs7Von0kBVpUCb96Pjw2cTrrpv1Z4i9u1OpfkNvGm2GHYJQhG/nLlk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L4UsYmnIRwpdWcmnfPRr/6J2MzPWeNkds7fNvjaDNihlbbMuhKa8I6orLgYt?=
 =?us-ascii?Q?rDkxqidk9disWvsf8mtVlAzYen0ci4BHxos1PNv571ZX8kCwW3hRaiobVYEA?=
 =?us-ascii?Q?E+6Mbubky8UVoOGTc9v9EBIw2mLG3uZb6uy7VamGqh0NaAhQ4CbQ8cNkqoOe?=
 =?us-ascii?Q?l35FPdzExu/icDjl2a9U7EdxBKPimtf8BJRxeLU1Wps/cOFReNC2AIIdmPB6?=
 =?us-ascii?Q?jlFgxcusacvpH3XzUpHOCKyngDLjX5mdme6HIKXaaCuP7h7/62gz/mieKoTz?=
 =?us-ascii?Q?LBsMbBeknKCnYueYvqccHO3Hjyb7G7zF91ejXfWVFwRY8t8X/ePDas6Vd6gB?=
 =?us-ascii?Q?BPZx8KIUhqz4bRenUHnQhEZXaof91aAxDpnL09cWpCt10zhobRqllfyPck0j?=
 =?us-ascii?Q?qPdPYLL9rUPBGxuK/F6QvYibVkcBHc/nKVxYZg7TVcPp+DX23nd6sA6lUWvJ?=
 =?us-ascii?Q?mRWCH5KW41cBlPcXuRxQ9+WsR7z2bVsR0lXUZn9Eu6x48GLNR7w5TTvfjCWg?=
 =?us-ascii?Q?IwWcWew1ZJ+3SbNWQIQQHGhYQ7xPXJu3hmQaa3J0ZYV3HYiXSVr49W1OodIX?=
 =?us-ascii?Q?Du68dErrD3Dc13xPMwhWO0sGT+NJiJW/+BxkLFO4gzSSpEgP29ehsadgd6a7?=
 =?us-ascii?Q?MrUWv7JrmiJQosktPS0HcgeFdPN0DxsAKInbOvpKAQIakNjRXog1mpBDIBQN?=
 =?us-ascii?Q?06Zr82p2s1arrIUnB54m2Nil7s7/G4Te/aE8Yc/JsdGiMJMfSSynAMthObOA?=
 =?us-ascii?Q?vdoIDrJILKsuodMAbf2bK1dhIHgxQxk7wwIebqWK7kHlJDyk1VCkQzl1EkQK?=
 =?us-ascii?Q?XycsaLl/xemkUFpZBObElI/WNDU2pWg3gA7Gjbj9Y1DOh8RSu97ucFnjuuH1?=
 =?us-ascii?Q?/1sUfOHchtX/jgGByENwX+zhusxdlQZQwgH5lfbnTNKN/weAA4dWbmEEXr6O?=
 =?us-ascii?Q?t3SA3jxSZ727j1gppg7gOVtN1u0ofXhpk7EOuzkrGUwM2nMM9TUYIzllsVb5?=
 =?us-ascii?Q?+lsMAj8HkQiB2PujUgiTF0ojRqAQk0ILFUOqA/FA75lcjSCqQgrdxbg3QEKo?=
 =?us-ascii?Q?9lShJnNM6p7PWF+YfzKsLRJb4bwXLUvDtjclbEoK1Zdo9BmzzDa4uMmOy4Ug?=
 =?us-ascii?Q?d9AmpAzbpeGiiglyqekOSb4cW+ldzrNVqUEStYiOZbZ+NlK21CV1ik58Dgk1?=
 =?us-ascii?Q?4FAbFdRmT+P6eUkZxyCEtLxUAqPKvCQV1ur/3TPpi6MSVJ5rxLQeDyKoD5Su?=
 =?us-ascii?Q?oK0gysbHcUiH09viqS3zD3glRs7vpcpwyvEgs6vHLyc22bI4q1sbxas2w4JR?=
 =?us-ascii?Q?Hz7M52iNgMQBwfVLuN9tDqUyWkSkoS+6caaCAtu+3VYNj19mh46SQaBKey4W?=
 =?us-ascii?Q?1MY3UXRplWFYYEF/OeBj93Qa2c47+/PGmeoXVx4dTe8MLLMkeaW2sUb4UAdG?=
 =?us-ascii?Q?VjiP8UfRDJD4niUBe1/8LK2jStc6aLBUQlVUWeIox6pA1kW4ULOyJgN1fGR4?=
 =?us-ascii?Q?22sv2w/Mkf0EwXq8u4JuMh7EEpMtDgn2OdKabOBz2dnmPhwkMfO0qX/PlfqN?=
 =?us-ascii?Q?05X/cv29bUts2lMvHhmDVwTSozkhuolnZVVQseMCAh0epTVrj9Hesy62WHfJ?=
 =?us-ascii?Q?0PGMY4ytOLYewO0OeYEmSAcjjzA0QTu+e9nDrBfrTWxdBLeE6FGMNEiUJ2QI?=
 =?us-ascii?Q?ftCWiPKvn70/57eU0z0zLXZCmT1T5VBN7hiFqJsxCMIBTGEt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96f72ef2-8c18-42d0-5197-08dea6052499
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:36:55.3160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yI/qB3t/ngkZ/9qI0y4n1+XVIRWrWA/2Qa8MJesn0i4PxYZnaWhcp+UHct2k24ui
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8881

collapse_file() is capable of collapsing pagecache folios from writable
files to PMD folios. Now enable clean pagecache folio collapse in addition
to read-only pagecache folio collapse by removing the
inode_is_open_for_write() from file_thp_enabled() and only performing
filemap_flush() if the file is read-only.

This means userspace needs to explicitly flush the content of pagecache
folios before khugepaged can collapse the folios, or use
madvise(MADV_COLLAPSE), which does the flush in the retry. The reason is
that blindly enabling dirty pagecache folio from writable files collapse
makes khugepaged flush these folios all the time. It is undesirable to
cause system level pagecache flushes.

To properly support dirty pagecache folio collapse, filemap_flush() needs
to be avoided. Potentially, merging associated buffer instead of dropping
it with filemap_release_folio() might be needed.

NOTE: this breaks khugepaged selftests for writable file pagecache
collapse, which is set to fail all the time. The next commit fix it.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 2 +-
 mm/khugepaged.c  | 9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9b3abb98a7e51..e1e9d59db6e70 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -97,7 +97,7 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
 		return false;
 
-	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
+	return S_ISREG(inode->i_mode);
 }
 
 /* If returns true, we are unable to access the VMA's folios. */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1ee15b48962a3..fb7ff643973cc 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2345,7 +2345,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 				 * forcing writeback in loop.
 				 */
 				xas_unlock_irq(&xas);
-				filemap_flush(mapping);
+				/*
+				 * Only flush for read-only files. Writable
+				 * files can have their folios dirty at any
+				 * time; blindly flushing them would cause
+				 * undesirable system-wide writeback.
+				 */
+				if (!inode_is_open_for_write(mapping->host))
+					filemap_flush(mapping);
 				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_test_writeback(folio)) {
-- 
2.53.0

