Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437A83CFF58
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 10:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780051565; cv=none; b=ubqQu//RoSGYbmcxrsdJCFRtCXhjitmC29AXOAeF7mZr5sByAT4XznJq5YwDpLHUowXTqa1FIVK2fTUdWrSTRL74+ehb9Gtn9a92e5NXbnt6F/4fdP9BD4KMkOhQSq9v6WxAI5uzhuwa24HbZLzELB/I6WNV8FKAWiou2sKQsmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780051565; c=relaxed/simple;
	bh=DhsIlFxS+Q3e9eLxfSz4zrFy1+m9jW+Xq4vWPo/sM80=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f78kQsFC94bBGAuKwWxkImtKuYRcWn0Gmx9uvWqIZkMFP0iK7OLTHNA0Bv42kDZGkoPhEYaFp/zeQOV49E4CnYqgC9RwfWoMtOrIIwnbJfoG+OjDgXpT/RCdOQ5ypdt912IHZ5GshW7wDd62tPu2oTnIrbmmReES3cXz0+aIk4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=uIZaPK5T; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="uIZaPK5T"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id 017DF32F957;
	Fri, 29 May 2026 11:39:39 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1780051180;
	bh=uI1eYhpAr22+BR18uiKHzK1HeJ4tN4HrVtZb9HWYgz0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=uIZaPK5TN2rwGFX7VBNxIrKkevmLkjJaTwjtILd0mJkXkVcUEwIbSHcrsLBf+EjU2
	 jTmNfd8E5exDkTaO1ZduYz8IjJDz5SKzEnr72E/R4pMWq41wea3zHaF/gPxxlu33No
	 FoYls2RS2VAoL2+ftlyMSmvoJFv/UuIPkFaE4s1w=
Message-ID: <c62070b7-c852-48d4-890c-6e1ed9d2d430@harmstone.com>
Date: Fri, 29 May 2026 11:39:39 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [linux-next:master] [btrfs] 551e510a97: fio.write_iops 12.4%
 improvement
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org
References: <202605291631.659bf248-lkp@intel.com>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <202605291631.659bf248-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Thanks for this Oliver, mind if I offer some constructive criticism?

1) Your fio script has both "buffered=0" and "direct=0", which are
contradictory. It looks like in this case fio treats it as "direct=1",
but this probably should be explicit.

2) Recent versions of btrfs fallback to buffered I/O unless nodatasum is
set. You probably want to add:

	mkdir /fs/sda1/nocow
	chattr +C /fs/sda1/nocow

and then change the directory to be /fs/sda1/nocow.

3) My experience is that for FS performance testing, the only way to get
useful figures is by PCI passthrough of an NVMe drive. Otherwise the VM
overhead is enough to skew the figures.

Mark

On 29/05/2026 10.04 am, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 12.4% improvement of fio.write_iops on:
> 
> 
> commit: 551e510a97a487218d5f22d61d1a3388ef1171ac ("btrfs: don't force DIO writes to be serialized")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> 
> testcase: fio-basic
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
> parameters:
> 
> 	runtime: 300s
> 	disk: 1HDD
> 	fs: btrfs
> 	nr_task: 1
> 	test_size: 128G
> 	rw: randwrite
> 	bs: 4k
> 	ioengine: falloc
> 	cpufreq_governor: performance
> 
> 
> In addition to that, the commit also has significant impact on the following tests:
> 
> +------------------+---------------------------------------------+
> | testcase: change | fio-basic: fio.write_iops 10.9% improvement |
> | test parameters  | bs=4k                                       |
> |                  | cpufreq_governor=performance                |
> |                  | disk=1HDD                                   |
> |                  | fs=btrfs                                    |
> |                  | ioengine=falloc                             |
> |                  | nr_task=1                                   |
> |                  | runtime=300s                                |
> |                  | rw=write                                    |
> |                  | test_size=128G                              |
> +------------------+---------------------------------------------+
> 
> 
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260529/202605291631.659bf248-lkp@intel.com
> 
> =========================================================================================
> bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
>   4k/gcc-14/performance/1HDD/btrfs/falloc/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/randwrite/lkp-icl-2sp9/128G/fio-basic
> 
> commit: 
>   964f569c14 ("btrfs: limit size of bios submitted from writeback")
>   551e510a97 ("btrfs: don't force DIO writes to be serialized")
> 
> 964f569c14d7778c 551e510a97a487218d5f22d61d1 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>       0.04 ±  5%      -0.0        0.04 ±  5%  fio.latency_4us%
>       5315           +12.4%       5976        fio.write_bw_MBps
>     510.67           -14.2%     438.00        fio.write_clat_90%_ns
>     515.00           -14.2%     442.00        fio.write_clat_95%_ns
>     522.67           -13.8%     450.67        fio.write_clat_99%_ns
>     496.01           -14.6%     423.39        fio.write_clat_mean_ns
>    1360660           +12.4%    1530010        fio.write_iops
>   1.67e+09           -10.0%  1.503e+09        cpuidle..time
>       1.48            +2.5%       1.51        iostat.cpu.system
>      42426            -6.0%      39867 ±  2%  meminfo.AnonHugePages
>     165506 ±  3%      -6.8%     154330        turbostat.IRQ
>       2392            +4.8%       2506        vmstat.system.cs
>       1945            +4.5%       2034        perf-stat.i.context-switches
>       1874            +4.1%       1949        perf-stat.ps.context-switches
>    1489031 ±110%    +162.9%    3915040 ±  3%  numa-meminfo.node0.FilePages
>      40746 ± 46%     +72.2%      70177 ±  5%  numa-meminfo.node0.KReclaimable
>      29851 ±122%    +178.8%      83225        numa-meminfo.node0.Mapped
>      40746 ± 46%     +72.2%      70177 ±  5%  numa-meminfo.node0.SReclaimable
>     126444 ± 22%     +29.1%     163254 ±  8%  numa-meminfo.node0.Slab
>    1485610 ±110%    +163.2%    3910117 ±  3%  numa-meminfo.node0.Unevictable
>    2626454 ± 62%     -92.4%     200365 ± 69%  numa-meminfo.node1.FilePages
>      56220 ± 65%     -95.9%       2321 ± 67%  numa-meminfo.node1.Mapped
>    2622239 ± 62%     -92.5%     197733 ± 70%  numa-meminfo.node1.Unevictable
>     372258 ±110%    +162.9%     978760 ±  3%  numa-vmstat.node0.nr_file_pages
>       7462 ±122%    +178.8%      20806        numa-vmstat.node0.nr_mapped
>      10186 ± 46%     +72.2%      17544 ±  5%  numa-vmstat.node0.nr_slab_reclaimable
>     371402 ±110%    +163.2%     977529 ±  3%  numa-vmstat.node0.nr_unevictable
>     371402 ±110%    +163.2%     977529 ±  3%  numa-vmstat.node0.nr_zone_unevictable
>     656614 ± 62%     -92.4%      50091 ± 69%  numa-vmstat.node1.nr_file_pages
>      14054 ± 65%     -95.9%     580.52 ± 67%  numa-vmstat.node1.nr_mapped
>     655559 ± 62%     -92.5%      49433 ± 70%  numa-vmstat.node1.nr_unevictable
>     655559 ± 62%     -92.5%      49433 ± 70%  numa-vmstat.node1.nr_zone_unevictable
>      80.52 ± 25%     -58.3       22.22 ±147%  perf-profile.calltrace.cycles-pp.__mmput.exit_mm.do_exit.do_group_exit.get_signal
>      80.52 ± 25%     -58.3       22.22 ±147%  perf-profile.calltrace.cycles-pp.exit_mm.do_exit.do_group_exit.get_signal.arch_do_signal_or_restart
>      80.52 ± 25%     -56.6       23.89 ±144%  perf-profile.calltrace.cycles-pp.exit_mmap.__mmput.exit_mm.do_exit.do_group_exit
>      68.85 ± 49%     -50.0       18.89 ±163%  perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.exit_mmap.__mmput.exit_mm
>      68.85 ± 49%     -50.0       18.89 ±163%  perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.exit_mmap.__mmput
>      68.57 ± 49%     -49.7       18.89 ±163%  perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.exit_mmap
>      68.85 ± 49%     -48.3       20.56 ±153%  perf-profile.calltrace.cycles-pp.unmap_vmas.exit_mmap.__mmput.exit_mm.do_exit
>      70.24 ± 51%     -48.0       22.22 ±147%  perf-profile.calltrace.cycles-pp.arch_do_signal_or_restart.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      70.24 ± 51%     -48.0       22.22 ±147%  perf-profile.calltrace.cycles-pp.do_exit.do_group_exit.get_signal.arch_do_signal_or_restart.exit_to_user_mode_loop
>      70.24 ± 51%     -48.0       22.22 ±147%  perf-profile.calltrace.cycles-pp.do_group_exit.get_signal.arch_do_signal_or_restart.exit_to_user_mode_loop.do_syscall_64
>      70.24 ± 51%     -48.0       22.22 ±147%  perf-profile.calltrace.cycles-pp.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      70.24 ± 51%     -48.0       22.22 ±147%  perf-profile.calltrace.cycles-pp.get_signal.arch_do_signal_or_restart.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      71.35 ± 48%     -45.8       25.56 ±142%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      71.35 ± 48%     -45.8       25.56 ±142%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
>      35.48 ± 64%     -24.4       11.11 ±223%  perf-profile.calltrace.cycles-pp.zap_present_ptes.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas
>      22.82 ± 62%     -18.4        4.44 ±147%  perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range
>      23.10 ± 64%     -15.9        7.22 ±169%  perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range
>      23.10 ± 64%     -15.9        7.22 ±169%  perf-profile.calltrace.cycles-pp.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas
>      12.38 ±118%     -12.4        0.00        perf-profile.calltrace.cycles-pp.lruvec_stat_mod_folio.folio_remove_rmap_ptes.zap_present_ptes.zap_pte_range.zap_pmd_range
>      15.99 ±131%     -10.4        5.56 ±223%  perf-profile.calltrace.cycles-pp.folio_remove_rmap_ptes.zap_present_ptes.zap_pte_range.zap_pmd_range.unmap_page_range
>      12.38 ±143%      -9.6        2.78 ±223%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
>      12.38 ±143%      -9.6        2.78 ±223%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
>      12.38 ±143%      -9.6        2.78 ±223%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
>      11.71 ± 98%      -7.3        4.44 ±147%  perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range
>      83.17 ± 23%     -59.3       23.89 ±144%  perf-profile.children.cycles-pp.__mmput
>      83.17 ± 23%     -59.3       23.89 ±144%  perf-profile.children.cycles-pp.exit_mmap
>      80.79 ± 24%     -58.6       22.22 ±147%  perf-profile.children.cycles-pp.arch_do_signal_or_restart
>      80.79 ± 24%     -58.6       22.22 ±147%  perf-profile.children.cycles-pp.get_signal
>      80.79 ± 24%     -56.9       23.89 ±144%  perf-profile.children.cycles-pp.do_exit
>      80.79 ± 24%     -56.9       23.89 ±144%  perf-profile.children.cycles-pp.do_group_exit
>      80.52 ± 25%     -56.6       23.89 ±144%  perf-profile.children.cycles-pp.exit_mm
>      75.95 ± 40%     -50.4       25.56 ±142%  perf-profile.children.cycles-pp.do_syscall_64
>      75.95 ± 40%     -50.4       25.56 ±142%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
>      68.85 ± 49%     -50.0       18.89 ±163%  perf-profile.children.cycles-pp.unmap_page_range
>      68.85 ± 49%     -50.0       18.89 ±163%  perf-profile.children.cycles-pp.zap_pmd_range
>      68.85 ± 49%     -50.0       18.89 ±163%  perf-profile.children.cycles-pp.zap_pte_range
>      68.85 ± 49%     -48.3       20.56 ±153%  perf-profile.children.cycles-pp.unmap_vmas
>      70.24 ± 51%     -48.0       22.22 ±147%  perf-profile.children.cycles-pp.exit_to_user_mode_loop
>      35.20 ± 66%     -26.9        8.33 ±223%  perf-profile.children.cycles-pp.zap_present_ptes
>      23.10 ± 64%     -15.9        7.22 ±169%  perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
>      23.10 ± 64%     -15.9        7.22 ±169%  perf-profile.children.cycles-pp.free_pages_and_swap_cache
>      23.10 ± 64%     -15.9        7.22 ±169%  perf-profile.children.cycles-pp.tlb_flush_mmu
>      19.33 ±102%     -13.8        5.56 ±223%  perf-profile.children.cycles-pp.folio_remove_rmap_ptes
>      12.38 ±143%      -9.6        2.78 ±223%  perf-profile.children.cycles-pp.kthread
>      12.38 ±143%      -9.6        2.78 ±223%  perf-profile.children.cycles-pp.ret_from_fork
>      12.38 ±143%      -9.6        2.78 ±223%  perf-profile.children.cycles-pp.ret_from_fork_asm
>       9.05 ±102%      -9.0        0.00        perf-profile.children.cycles-pp.lruvec_stat_mod_folio
>      11.71 ± 98%      -7.3        4.44 ±147%  perf-profile.children.cycles-pp.folios_put_refs
>      15.60 ± 97%     -15.6        0.00        perf-profile.self.cycles-pp.zap_present_ptes
>      13.61 ±107%      -8.1        5.56 ±223%  perf-profile.self.cycles-pp.folio_remove_rmap_ptes
>      10.28 ± 94%      -6.9        3.33 ±223%  perf-profile.self.cycles-pp.zap_pte_range
> 
> 
> ***************************************************************************************************
> 
> =========================================================================================
> bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
>   4k/gcc-14/performance/1HDD/btrfs/falloc/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/write/lkp-icl-2sp9/128G/fio-basic
> 
> commit: 
>   964f569c14 ("btrfs: limit size of bios submitted from writeback")
>   551e510a97 ("btrfs: don't force DIO writes to be serialized")
> 
> 964f569c14d7778c 551e510a97a487218d5f22d61d1 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>       0.04 ±  4%      -0.0        0.04 ±  4%  fio.latency_4us%
>       6156           +10.9%       6825        fio.write_bw_MBps
>     459.33           -13.5%     397.33        fio.write_clat_90%_ns
>     462.00           -13.7%     398.67 ±  2%  fio.write_clat_95%_ns
>     466.67           -13.6%     403.33 ±  2%  fio.write_clat_99%_ns
>     454.12           -14.1%     389.87        fio.write_clat_mean_ns
>    1575955           +10.9%    1747309        fio.write_iops
>     556943 ± 91%     -62.8%     207326 ±184%  sched_debug.cfs_rq:/.load.max
>     152355 ±  2%      -7.7%     140620 ±  3%  turbostat.IRQ
>  1.472e+09 ±  2%      -9.2%  1.337e+09        cpuidle..time
>      99291 ±  3%      -7.8%      91524 ±  4%  cpuidle..usage
>       9.05 ±102%      -9.0        0.00        perf-profile.calltrace.cycles-pp.free_pgtables.exit_mmap.__mmput.exit_mm.do_exit
>       9.05 ±102%      -7.4        1.67 ±223%  perf-profile.children.cycles-pp.free_pgtables
> 
> 
> 
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> 

