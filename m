Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18.italiaonline.it ([212.48.25.146]:50749 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752787AbbK2OHq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Nov 2015 09:07:46 -0500
Reply-To: kreijack@inwind.it
Subject: Re: BTRFS: could not find root 8
References: <CAK5rZE7_f6cypBPTR8UX-7t=OnRE595XBw__kN6Gy2cNowGFgA@mail.gmail.com>
 <20151127204305.GE24333@carfax.org.uk>
 <CAJCQCtQgjbR77eei2-srOofBLpWp-avj_2OMCRa_4Ffby8eL5g@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Imran Geriskovan <imran.geriskovan@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <565B06AF.9020806@inwind.it>
Date: Sun, 29 Nov 2015 15:07:43 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQgjbR77eei2-srOofBLpWp-avj_2OMCRa_4Ffby8eL5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-11-27 23:51, Chris Murphy wrote:
> But from github I'm not finding any indication that systemd enables
> quota. This issue suggests that quota disabled is tolerated.
> https://github.com/systemd/systemd/issues/1809

Looking at the systemd source, it seems that it could enable quota when playing with the "machine":


See src/shared/machine-pool.c:

int setup_machine_directory(uint64_t size, sd_bus_error *error) {
        _cleanup_release_lock_file_ LockFile lock_file = LOCK_FILE_INIT;
        struct loop_info64 info = {
                .lo_flags = LO_FLAGS_AUTOCLEAR,
[...]
        r = check_btrfs();
        if (r < 0)
                return sd_bus_error_set_errnof(error, r, "Failed to determine whether /var/lib/machines is located on btrfs: %m");
        if (r > 0) {
                (void) btrfs_subvol_make_label("/var/lib/machines");

                r = btrfs_quota_enable("/var/lib/machines", true);
[...]

But I was unable to understand if:
- enabling quota is a "per filesystem" attribute or per "subvolume attribute"
- when systemd invokes setup_machine_directory()

Does someone have more information ?

BR


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
