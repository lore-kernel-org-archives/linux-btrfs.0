Received: from altprdrgo003.altice.prod.cloud.openwave.ai (altprdrgo003.altice.prod.cloud.openwave.ai [66.179.105.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E1B381C4
	for <linux-btrfs@vger.kernel.org>; Sun, 16 Aug 2026 03:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.179.105.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786851983; cv=none; b=eMhMfoTpjrJ7Se1mzB8INQwO+X4iN8n29vQzHYr+LvNwSf5OLhnxXZvE3WRf8AmmHph1MUAJ8Hr3wjhsT10VQP6oOo5NQcsl+oaneH/yCAthM996jpxO5PURQifM5gc5Qf+OJEU0dLPZaJYEuXhLM6ggRLk7ZwnO9wg+asVFQoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786851983; c=relaxed/simple;
	bh=tgtNsgPjyAAKO8+JxbHBb8UpopVQN+zBA0sCdPwNb9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JieUP1Z+pgBzXfvNsdC/WjcPDOCrxkCQMnmED/kfZwSyLwQRHg5bsSRceOvHUv2an6uw4Hy2Dlmg6dUdlqDdyZv27t1E8PiCYWAm9QuAbDSSoWLmMQhI+trjAoPwlc74hRN1OT7iAbNqc6piykxO9Mr3OHG2Mjp/9VKb4KiAFoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=optonline.net; spf=pass smtp.mailfrom=optonline.net; dkim=pass (2048-bit key) header.d=optonline.net header.i=@optonline.net header.b=DK9oHMnN; arc=none smtp.client-ip=66.179.105.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=optonline.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=optonline.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=optonline.net header.i=@optonline.net header.b="DK9oHMnN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=optonline.net; s=dkim-002; t=1786851980; 
        bh=hBoMFCccPNT9HLC9Im3E/J3Nr4WFNTi1i+aqD8V8Opg=;
        h=From:To:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version;
        b=DK9oHMnNksRw+pyXWMGG44btUiTZPjo+q80ufqlXobrMm9C+jl/IKCfR4lpq5iBZ4VKjO7P+9YiKL4edRTWJY/99j38TTW/6yABpuoYmLhAcQpO0N55XpgEtbiuhwC2mW+H4DcaXM7h5m8ge0wV8W0wJzwmOdng85pw+X4kA7G9ETPSTyKjERYkmpRVP51wtJRG7F/ATiNGakTH7xbQxZG6XM918Q0yc03zmNrx7f3s6K0PBIHd4l6qiceAa+EDOI5aA9N2Ye6R6IaT4XVKKQTswwNo0Uy66hDNzyO/ZA3l1xXgemBR8lFGidU9zY2NBFPBRtof88RI1Yt8xfqsOVA==
X-RG-VS-CS: clean
X-RG-VS-SC: 0
X-RG-VS: Clean
X-RG-Env-Sender: jamesowens@optimum.net
X-RG-Rigid: 6A809188001653F8
X-RazorGate-Vade: dmFkZTF+Au+gZHdTLcdrnnqKQnzOHm8Hb2DZ8SpqMpa/eJruDAR7IgJO57wSdFxAJ0/1W7oi6kxLb8U7eTDgChXhDSrfFU4KRBV64+93BeKhS819J3ckUQoGOOIOX010pDv01UGLQDkRwP99JT5OK+FbDUIHM1a0xCSeqG0FGzmboVZeCYGDZIE8PXl1nOony9gSFMz1f7d0iVw0g9zaGorZ5Z6SEI1rHchoEMlyKkQQGgSTMkejnvdiCz9GREo9X6rNlfVk7u4gNIWYvaeVye2ILKL7HeG5fIH2yDtWTUq0Z65XlzvONERcUCU1N2zp7RDBCuATrAU1tY2lbWOZHGh1+GQ2Ng2qu8oDDThTLRChrYUgFrqf/PfRL5KItxolo9Hhwwvp0dcunbmx/zCrkJxfm46C1H85Lq/xD/R2JARe435zX7di11D5VBZu6PCF2QXjNsaJ74fJQWOLXrCpIK6urtxBj2XxKIfVzw/ZkT4RbIgAWLSvVCIGxkctECZDcg55Fpq1YFRkwLb81aF9SqUWHkDZLpswstVaa8hyVIkXOyeB0REzkqEvYHqDHej4W56lio2y+2mfEJAAKNLGxWbJM5QJuhH1ezEj0vli/usrUkc7wV4A2sf/DPGIk8tbHvvXtL3RM1Kjgd3Utck8Ex66sIjEaXe9VyB0cOuxShFu5MpPdQ
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from jco-monster-ng.jcowens.net (68.197.170.124) by altprdrgo003.altice.prod.cloud.openwave.ai (authenticated as jamesowens)
        id 6A809188001653F8; Sat, 15 Aug 2026 23:35:26 -0400
From: "James C. Owens" <jamesowens@optonline.net>
To: wqu@suse.com
Cc: boris@bur.io,
	dsterba@suse.com,
	lionel-subscription@bouton.name,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: scrub: report the failing sector's address, not the stripe base
Date: Sat, 15 Aug 2026 23:35:05 -0400
Message-ID: <20260816033505.1901423-1-jamesowens@optonline.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <d0cbcb52-5f28-49c6-98f0-85ccce33d845@suse.com>
References: <20260814162405.1434693-1-jamesowens@optonline.net> <20260815153416.138869-1-jamesowens@optonline.net> <d0cbcb52-5f28-49c6-98f0-85ccce33d845@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Aug 16, 2026 at 07:43:47AM +0930, Qu Wenruo wrote:
> Great that the mystery got solved!

Thanks for applying it. Here is what it turned out to be, for the archive. Not
a btrfs bug, no action wanted.

VMware's vmmon pins the pages of an mmapped file with
get_user_pages_fast(..., 0, ...) and registers no mmu_notifier, so the guest
keeps writing through EPT after folio_mkclean() has write-protected the PTEs.
btrfs checksums a page that is still changing. Nothing was corrupt; the
checksums described bytes that were already stale.

This is not an old build: Workstation 26.0.0 build 25388281 (26H1), the
current release.

The file is /tmp/vmware-<user>/ramNNN - despite the name, ~25 MB of device
emulation state, not guest RAM. It only lands on btrfs because /tmp here is a
subvolume rather than tmpfs, an openSUSE layout inherited from 15.x. Fresh
Leap 16 installs get tmpfs and are immune.

Storage-independent - I hit it on btrfs/LVM/md-RAID1 and on btrfs directly over
a 3ware hardware-RAID LU, one device as far as Linux is concerned.

What I found interesting: mm/gup.c already refuses this.
writable_file_mapping_allowed() rejects a long-term writable pin of a
dirty-tracked file mapping, and pin_user_pages.rst CASE 5 names this exact code
shape as the INCORRECT pattern. But with gup_flags = 0, check_vma_flags()
computes write = (gup_flags & FOLL_WRITE) = 0 and never reaches the check.
Declaring FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE would have failed -EFAULT at VM
start instead of surfacing months later as apparent corruption. Reporting that
to the vendor.

Possibly useful for triage, since it makes the symptom look impossible: on md
the same page mutation leaves the mirrors holding different bytes, because
raid1_write_request() clones the bio and the clones point at the same pages.

    logical 0x19AF05000     stored csum   c615d429
      nvme2n1  327e401c
      nvme0n1  327e401c
      nvme1n1  c615d429     <- matches the stored checksum

mismatch_cnt was 2176; the RAID6 array on the same host reads 0. Invisible on
hardware RAID, where mirroring happens below Linux. So if a report here ever
describes csum errors on btrfs-over-md-RAID1, reading each member directly is
worth doing before believing the filesystem.

The intermittency I reported earlier in this thread was just extent churn - the
file is rewritten constantly, so flagged extents get freed and reallocated.

This may also be worth a second look:

  https://lore.kernel.org/linux-btrfs/c2fa6c37-d2a8-4d77-b095-e04e3db35ef0@bouton.name/

Lionel Bouton (cc'd), June 2024 - "scrub reports uncorrectable csum errors linked to
readable file (data: single)". Same profile as mine: uncorrectable csum=N with
corrected=0, all errors on one file, the count multiplied by snapshots, and the
file reading back perfectly fine. That thread ends with "Let me dig deeper to
find out why" and no conclusion. His setup was different - a QEMU/KVM guest on
Ceph RBD rather than a VMware host - so I am not claiming the same cause, only
that the symptom profile is identical and an unmanaged writer would produce it.

Which connects to 7ca3e84980ef ("btrfs: reject out-of-band dirty folios during
writeback"): "This used to be a problem related to get_user_page(), but with the
introduction of pin_user_pages*(), we should no longer hit such case anymore."
That assumption has at least one shipping counterexample.

Cc'ing Boris since the fixup worker has just been reinstated via dirty_folio().

Workaround is chattr +C on /tmp and on every pre-existing directory beneath it,
since the flag is inherited at creation only.

Thanks,
James
