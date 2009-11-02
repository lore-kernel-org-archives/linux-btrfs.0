From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Kernel [BUG] trace on suspend.
Date: Mon, 2 Nov 2009 10:36:27 -0500
Message-ID: <20091102153627.GD1565@think>
References: <4AEB21B4.3040603@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Michael Raskin <7c6f434c@mail.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AEB21B4.3040603@mail.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 30, 2009 at 08:26:12PM +0300, Michael Raskin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 	Attached find a dmesg snapshot. Configuration: Zen-kernel 2.6.31-zen5
> with TuxOnIce and BtrFS, suspend from console.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.12 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQEcBAEBAgAGBQJK6yGyAAoJEE6tnN0aWvw3I+MIAKD0PSuvF4GvuX3ZZj805ahD
> InantIlWub4vYtUu/LnkqE574waAnjulXrSK8I3WLj1Pv1or9jhSLY+8HxzaG7Ag
> N9k8i0UWiFMg2XABQPCesbts542wyKBN9bXmt6m49o4F0LmrcuiCk7LhfJV/An6R
> cX9/KpgdDCvJd8akljfHkvnaLJs07F+FEPZcDMipbqy7X2o1pr7FfnhvVki3GC95
> r0Z+ErrZrHpyRbi8BGygiTZxAoZDJ35KC1nAlDR01JXMBzYrqApptQ4uPeJbj259
> nOYPNKAwD2zdUfbC0N2GiTpGbpV6pn6XgWEfeVkP/WxmvL4OgdqVqpq5vKxzisU=
> =ueAW
> -----END PGP SIGNATURE-----

> [ 3233.289136] Initiating a hibernation cycle.
> [ 3233.289360] TuxOnIce: Userui disabled.
> [ 3233.289366] Freezing processes & syncing filesystems.
> [ 3233.289396] Stopping fuse filesystems.
> [ 3233.289403] Freezing user space processes ... (elapsed 0.00 seconds) done.
> [ 3233.290387] Stopping normal filesystems.
> [ 3233.304122] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> [ 3233.347382] Preparing Image. Try 1.
> [ 3233.348853] Restarting normal filesystems.
> [ 3233.386864] Stopping fuse filesystems.
> [ 3233.386886] Freezing user space processes ... (elapsed 0.00 seconds) done.
> [ 3233.387014] Stopping normal filesystems.
> [ 3233.388751] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> [ 3233.441488] Starting to save the image..
> [ 3233.442305] Writing caches...
> [ 3235.444557] ...20%...40%...60%...80%...100%
> [ 3243.580723] Waited for i/o due to synchronous I/O 5 times.
> [ 3243.580726] Waited for i/o due to throughput_throttle 2829 times.
> [ 3243.580731] Doing atomic copy/restore.
> [ 3243.581526] Suspending console(s) (use no_console_suspend to debug)
> [ 3243.581787] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 3243.652009] radeonfb (0000:01:05.0): suspending for event: 1...
> [ 3243.684027] HDA Intel 0000:00:14.2: PCI INT A disabled
> [ 3243.700104] pata_atiixp 0000:00:14.1: PCI INT A disabled
> [ 3244.528007] ata1: softreset failed (device not ready)
> [ 3244.528010] ata1: applying SB600 PMP SRST workaround and retrying
> [ 3244.692018] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [ 3244.692949] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
> [ 3244.694003] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
> [ 3244.694006] ata1.00: configured for UDMA/100
> [ 3244.694144] ahci 0000:00:12.0: PCI INT A disabled
> [ 3244.695137] ACPI: Preparing to enter system sleep state S4
> [ 3244.695862] PM: Saving platform NVS memory
> [ 3244.704665] Disabling non-boot CPUs ...
> [ 3244.704724] Extended CMOS year: 2000
> [ 3244.704724] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [ 3244.704724] Intel machine check architecture supported.
> [ 3244.704724] Intel machine check reporting enabled on CPU#0.
> [ 3244.704724] mce: CPU supports 6 MCE banks
> [ 3244.704724] PM: Restoring platform NVS memory
> [ 3244.704724] Extended CMOS year: 2000
> [ 3244.704724] ACPI: Waking up from system sleep state S4
> [ 3244.788092] unable to find logical 137439014912 len 4096

Well, this looks like metadata corruption.  In general I haven't been
testing with suspend to disk, was the FS consistent after a reboot?

-chris
