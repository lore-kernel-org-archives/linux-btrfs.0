Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE03ECDE46
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 23:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78A482085B
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 23:00:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78A482085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727583AbeJ0HjS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Oct 2018 03:39:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:4196 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbeJ0HjS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Oct 2018 03:39:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Oct 2018 16:00:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,429,1534834800"; 
   d="gz'50?scan'50,208,50";a="103030794"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 26 Oct 2018 16:00:21 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gGB5Y-0004cO-VQ; Sat, 27 Oct 2018 07:00:20 +0800
Date:   Sat, 27 Oct 2018 06:59:24 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kbuild-all@01.org, linux-btrfs@vger.kernel.org
Subject: [josef-btrfs:kill-mmap-sem-v5 9/10] htmldocs: mm/filemap.c:2882:
 warning: Function parameter or member 'mkwrite' not described in
 'filemap_page_mkwrite_nommapsem'
Message-ID: <201810270620.0zVnLdHX%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git kill-mmap-sem-v5
head:   c7a3e899803d98ae543468f0026500c651528a6c
commit: c52634339df10df75f28787f431b937de3c3c591 [9/10] mm: introduce filemap_page_mkwrite_nommapsem
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   WARNING: convert(1) not found, for SVG to PDF conversion install ImageMagick (https://www.imagemagick.org)
   include/linux/srcu.h:175: warning: Function parameter or member 'p' not described in 'srcu_dereference_notrace'
   include/linux/srcu.h:175: warning: Function parameter or member 'sp' not described in 'srcu_dereference_notrace'
   include/linux/gfp.h:1: warning: no structured comments found
>> mm/filemap.c:2882: warning: Function parameter or member 'mkwrite' not described in 'filemap_page_mkwrite_nommapsem'
   mm/filemap.c:2882: warning: Excess function parameter 'page_mkwrite_cb' description in 'filemap_page_mkwrite_nommapsem'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.connect' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.keys' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.ie' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.ie_len' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.bssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.ssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.default_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.default_mgmt_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.prev_bssid_valid' not described in 'wireless_dev'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'
   include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'

vim +2882 mm/filemap.c

  2851	
  2852	/**
  2853	 * filemap_page_mkwrite_nommap_sem - handle dropping the mmap_sem and caching
  2854	 *		the resulting page from the fs's mkwrite callback.
  2855	 * @vmf:		struct vm_fault containing details of the fault
  2856	 * @page_mkwrite_cb:	the fs specific mkwrite callback
  2857	 *
  2858	 * Some file systems have very heavy mkwrite operations, which means that we can
  2859	 * hold the mmap_sem for long periods of time.  This can cause weird priority
  2860	 * inversions in the system if something tries to take a write lock on the
  2861	 * mmap_sem, which will block any new readers until the writer has done its
  2862	 * work.
  2863	 *
  2864	 * This helper allows file systems to opt-in to a mechanism that will handle
  2865	 * dropping the mmap_sem during the mkwrite, and then caching the result and
  2866	 * re-using the page in the next loop through the fault handler as long as it is
  2867	 * still valid.
  2868	 *
  2869	 * Users of this helper must be sure to _never_ access vmf->vma as it could be
  2870	 * invalid, instead they need to access vmf->file as that will either be pinned
  2871	 * because we grabbed a reference before dropping the mmap_sem, or we still have
  2872	 * the mmap_sem and thus is still save to look at.
  2873	 *
  2874	 * vma->vm_mm->mmap-sem must be held on entry.
  2875	 *
  2876	 * If our return value has VM_FAULT_RETRY set then the mmap_sem has been
  2877	 * dropped, otherwise it is still held.
  2878	 */
  2879	vm_fault_t filemap_page_mkwrite_nommapsem(struct vm_fault *vmf,
  2880						  page_mkwrite_cb *mkwrite)
  2881	{
> 2882		struct mm_struct *mm = vmf->vma->vm_mm;
  2883		struct page *page = vmf->page;
  2884		struct file *file = vmf->vma->vm_file;
  2885		struct file *fpin;
  2886		vm_fault_t ret;
  2887	
  2888		/*
  2889		 * Our page is already initialized from a previous loop through the
  2890		 * fault handler, so lock it and check if it is valid, and if it is
  2891		 * simply return.
  2892		 */
  2893		if (vmf->flags & FAULT_FLAG_PAGE_INITIALISED) {
  2894			lock_page(page);
  2895			if (initialised_page_valid(vmf, page))
  2896				return VM_FAULT_LOCKED;
  2897			unlock_page(page);
  2898		}
  2899	
  2900		/*
  2901		 * mkwrite can be expensive, so drop the mmap_sem for this operation and
  2902		 * deal with caching the page for the next trip around.
  2903		 */
  2904		fpin = maybe_unlock_mmap_for_io(vmf->vma, vmf->flags);
  2905		vmf->file = file;
  2906		ret = mkwrite(vmf);
  2907		if (fpin) {
  2908			if (ret == VM_FAULT_LOCKED)
  2909				unlock_page(page);
  2910			fput(fpin);
  2911	
  2912			/*
  2913			 * We had an error when doing mkwrite, instead of looping
  2914			 * through again just down_read the mmap_sem and return the
  2915			 * error.  Otherwise cache the page for the next trip through.
  2916			 */
  2917			if (ret & VM_FAULT_ERROR) {
  2918				down_read(&mm->mmap_sem);
  2919			} else {
  2920				get_page(page);
  2921				vmf->cached_page = page;
  2922				ret = VM_FAULT_RETRY;
  2923			}
  2924		}
  2925		return ret;
  2926	}
  2927	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--cWoXeonUoKmBZSoM
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--cWoXeonUoKmBZSoM--
