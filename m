Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36355 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbcELPnn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 11:43:43 -0400
Received: by mail-ig0-f179.google.com with SMTP id lr7so57394957igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 08:43:42 -0700 (PDT)
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
To: =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>,
        linux-btrfs@vger.kernel.org
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
 <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
 <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
 <20160505174854.GA1012@vader.dhcp.thefacebook.com>
 <585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
 <2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
 <CAFvQSYTQ1yZqPYyv0dmd+JuHRWfKm-RtZLdbKXQeHiWMthnyLw@mail.gmail.com>
 <f1dd07efb34a0a110f62566979530944@linuxsystems.it>
 <799cf552-4612-56c5-b44d-59458119e2b0@gmail.com>
 <52f0c710-d695-443d-b6d5-266e3db634f8@linuxsystems.it>
 <20160509162940.GC15597@hungrycats.org>
 <c5fa6a35-f6bd-4546-8297-7f6225696157@linuxsystems.it>
Cc: Clemens Eisserer <linuxhippy@gmail.com>,
        Patrik Lundquist <patrik.lundquist@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, 1i5t5.duncan@cox.net
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a3a4e412-221d-c12b-284b-af53e4738211@gmail.com>
Date: Thu, 12 May 2016 11:43:38 -0400
MIME-Version: 1.0
In-Reply-To: <c5fa6a35-f6bd-4546-8297-7f6225696157@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-12 10:35, Niccolò Belli wrote:
> On lunedì 9 maggio 2016 18:29:41 CEST, Zygo Blaxell wrote:
>> Did you also check the data matches the backup?  btrfs check will only
>> look at the metadata, which is 0.1% of what you've copied.  From what
>> you've written, there should be a lot of errors in the data too.  If you
>> have incorrect data but btrfs scrub finds no incorrect checksums, then
>> your storage layer is probably fine and we have to look at CPU, host RAM,
>> and software as possible culprits.
>>
>> The logs you've posted so far indicate that bad metadata (e.g. negative
>> item lengths, nonsense transids in metadata references but sane transids
>> in the referred pages) is getting into otherwise valid and well-formed
>> btrfs metadata pages.  Since these pages are protected by checksums,
>> the corruption can't be originating in the storage layer--if it was, the
>> pages should be rejected as they are read from disk, before btrfs even
>> looks at them, and the insane transid should be the "found" one not the
>> "expected" one.  That suggests there is either RAM corruption happening
>> _after_ the data is read from disk (i.e. while the pages are cached in
>> RAM), or a severe software bug in the kernel you're running.
>
> When doing the btrfs check I also always do a btrfs scrub and it never
> found any error. Once it didn't manage to finish the scrub because of:
> BTRFS critical (device dm-0): corrupt leaf, slot offset bad:
> block=670597120,root=1, slot=6
> and btrfs scrub status reported "was aborted after 00:00:10".
>
> Talking about scrub I created a systemd timer to run scrub hourly and I
> noticed 2 *uncorrectable* errors suddenly appeared on my system. So I
> immediately re-run the scrub just to confirm it and then I rebooted into
> the Arch live usb and runned btrfs check: the metadata were perfect. So
> I runned btrfs scrub from the live usb and there were no errors at all!
> I rebooted into my system and runned scrub once again and the
> uncorrectable errors where really gone! It happened two times in the
> past few days.
This would indicate to me that you've either got bad RAM (most likely), 
or some other hardware component is not working correctly.  It's not 
unusual for hardware issues to be intermittent.
>
>> Try different kernel versions (e.g. 4.4.9 or 4.1.23) in case whoever
>> maintains your kernel had a bad day and merged a patch they should
>> not have.
>
> Almost no patches get applied by the Arch kernel team:
> https://git.archlinux.org/svntogit/packages.git/tree/trunk?h=packages/linux
> At the moment the only one is an harmless
> "change-default-console-loglevel.patch".
>
>> Try a minimal configuration with as few drivers as possible loaded,
>> especially GPU drivers and anything from the staging subdirectory--when
>> these drivers have bugs, they ruin everything.
>
> Arch kernel team is quite conservative regarding staging/experimental
> features, I remember they rejected some config patches I submitted
> because of this.
> Anyway I will try to blacklist as many kernel modules as I can. Maybe
> blacklisting GPU is too much because if I can't actually use my laptop
> it will be much more difficult to reproduce the issue.
Disable the GPU driver, but make sure you have the VGA_CONSOLE config 
enabled, and you should be fine (you'll just get a 80x25 text-mode 
console instead of a high-resolution one).
>
>> Try memtest86+ which has a few more/different tests than memtest86.
>> I have encountered RAM modules that pass memtest86 but fail memtest86+
>> and vice versa.
>>
>> Try memtester, a memory tester that runs as a Linux process, so it can
>> detect corruption caused when device drivers spray data randomly into
>> RAM,
>> or when the CPU thermal controls are influenced by Linux (an overheating
>> CPU-to-RAM bridge can really ruin your day, and some of the dumber laptop
>> designs rely on the OS for thermal management).
>>
>> Try running more than one memory testing process, in case there is a bug
>> in your hardware that affects interactions between multiple cores
>> (memtest
>> is single-threaded).  You can run memtest86 inside a kvm (e.g. kvm
>> -m 3072 -kernel /boot/memtest86.bin) to detect these kinds of issues.
>>
>> Kernel compiles are a bad way to test RAM.  I've successfully built
>> kernels on hosts with known RAM failures.  The kernels don't always work
>> properly, but it's quite rare to see a build fail outright.
>
> I didn't use memtest86+ because of the lack of EFI support, but I just
> tried the shiny new memtest86 7.0 beta with improved tests for 12+ hours
> without issues.
> Also I runned "memtester 4G" and "systester-cli -gausslg 64M -threads 4
> -turns 100000" together for 12 hours without any issue so I think both
> my ram and cpu are ok.
That's probably a good indication of the CPU and the MB being OK, but 
not necessarily the RAM.  There's two other possible options for testing 
the RAM that haven't been mentioned yet though (which I hadn't thought 
of myself until now):
1. If you have access to Windows, try the Windows Memory Diagnostic. 
This runs yet another slightly different set of tests from memtest86 and 
memtest86+, so it may catch issues they don't.  You can start this 
directly on an EFI system by loading /EFI/Microsoft/Boot/MEMTEST.EFI 
from the EFI system partition.
2. This is a Dell system.  If you still have the utility partition which 
Dell ships all their per-provisioned systems with, that should have a 
hardware diagnostics tool.  I doubt that this will find anything (it's 
part of their QA procedure AFAICT), but it's probably worth trying, as 
the memory testing in that uses yet another slightly different 
implementation of the typical tests.  You can usually find this in the 
boot interrupt menu accessed by hitting F12 before the boot-loader loads.
>
> I can think only about two possible culprits now (correct me if I'm wrong):
> 1) A btrfs bug
> 2) Another module screwing things around
It could still be the disk (not likely, but possible) or the storage 
controller.  If you have a spare disk, I'd suggest trying with that 
(assuming of course it doesn't void your warranty).
>
> I can do nothing about btrfs bugs so I will try to hunt the second
> option. This is the list of modules I'm running:
>
> lsmod | awk '$4 == ""' | awk '{print $1}' | sort
>
> 8250_dw
> ac
> acpi_als
> acpi_pad
> aesni_intel
> ahci
> algif_skcipher
> ansi_cprng
> arc4
> atkbd
> battery
> bnep
> btrfs
> btusb
> cdc_ether
> cmac
> coretemp
> crc32c_intel
> crc32_pclmul
> crct10dif_pclmul
> dell_laptop
> dell_wmi
> dm_crypt
> drbg
> ecb
> elan_i2c
> evdev
> ext4
> fan
> fjes
> ghash_clmulni_intel
> gpio_lynxpoint
> hid_generic
> hid_multitouch
> hmac
> i2c_designware_platform
> i2c_hid
> i2c_i801
> i915
> input_leds
> int3400_thermal
> int3402_thermal
> int3403_thermal
> intel_hid
> intel_pch_thermal
> intel_powerclamp
> intel_rapl
> ip_tables
> iTCO_wdt
> iwlmvm
> jitterentropy_rng
> joydev
> kvm_intel
> lpc_ich
> mac_hid
> mei_me
> mos7720
> mousedev
> msr
> nls_cp437
> nls_iso8859_1
> nvram
> pcspkr
> pl2303
> processor
> processor_thermal_device
> psmouse
> r8152
> rfcomm
> rtsx_pci_ms
> rtsx_pci_sdmmc
> sch_fq_codel
> sdhci_acpi
> sd_mod
> serio_raw
> sha256_ssse3
> shpchp
> snd_hda_codec_hdmi
> snd_hda_intel
> snd_soc_ssm4567
> snd_soc_sst_acpi
> snd_soc_sst_broadwell
> spi_pxa2xx_platform
> thermal
> tpm_crb
> tpm_tis
> uas
> usbhid
> uvcvideo
> vfat
> visor
> x86_pkg_temp_thermal
> xhci_pci
>
> I will try to blacklist as many as I can will still keeping a somehow
> usable system and see if can reproduce it. If I will not be able to
> reproduce it anymore then the hunt will begin. It will not be a funny
> one as I already experienced with hid-multitouch which gave me random
> kernel hangs at boot ONLY if loaded early into the initramfs:
> https://bugzilla.kernel.org/show_bug.cgi?id=105251
Based on what you've got listed for modules, I'd expect the absolute 
minimum for a usable test system to be:
  ac
  acpi_als (you can probably remove this, it's for the ambient light sensor)
  acpi_pad
  ahci
  atkbd
  battery
  btrfs
  coretemp
  dell_laptop
  dell_wmi
  elan_i2c
  evdev
  ext4
  fan
  gpio_lynxpoint
  hid_generic
  hid_multitouch
  i2c_i801
  i915 (this is your GPU module, you should still have a usable text 
console if this isn't loaded)
  int3400_thermal
  int3402_thermal
  int3403_thermal
  intel_hid
  intel_pch_thermal
  intel_powerclamp
  intel_rapl
  ip_tables (if you have no firewall configured, you can safely 
blacklist this)
  iwlmvm (you might try removing this, but you will have no wifi without it)
  lpc_ich
  mousedev
  nvram (you might be able to remove this, I don't remember if the dell 
modules depend on it or not)
  processor
  processor_thermal_device
  psmouse
  r8152 (you can try removing this too, but you will have no ethernet 
without it)
  sch_fq_codel
  serio_raw
  spi_pxa2xx_platform
  thermal
  usbhid
  vfat (if you avoid mounting your EFI system partition, you can 
probably pull this out)
  x86_pkg_temp_thermal
  xhci_pci
Note that this assumes you aren't testing on dmcrypt.  Make absolutely 
certain though that you don't remove any of the *thermal modules, the 
fan module, and the dell modules, not having those may result in 
hardware damage.
