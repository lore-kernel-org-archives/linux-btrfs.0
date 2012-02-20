From: Curtis Jones <curtis.jones@gmail.com>
Subject: Re: btrfs open_ctree failed (after recent Ubuntu update)
Date: Sun, 19 Feb 2012 22:34:04 -0500
Message-ID: <E271A902-2E12-494D-85D2-FFFD9362FC30@gmail.com>
References: <455D7450-3946-478A-9021-6B01A4D7FB9B@gmail.com> <201202191000.34819.chris@csamuel.org> <FA65D86B-2BF3-49C9-941D-04AFF239523D@gmail.com> <201202192141.13497.chris@csamuel.org>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201202192141.13497.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

Thank you for those kernel-update instructions. That was the least painful kernel update I could have imagined. I rebooted and verified (via uname) that I am in fact running the new kernel. After looking at dmesg I can confirm that the exact same error is still occurring though. I re-read your previous email and saw that you recommended the 3.3-rc release if 3.2.6 didn't suffice. So I did the same thing with 3.3-rc. And I found the same error (or what appears to be the same error), again:

> [  186.982910] device label StoreW devid 1 transid 37077 /dev/sdb
> [  187.015081] parent transid verify failed on 79466496 wanted 33999 found 36704
> [  187.015088] parent transid verify failed on 79466496 wanted 33999 found 36704
> [  187.015091] parent transid verify failed on 79466496 wanted 33999 found 36704
> [  187.015094] parent transid verify failed on 79466496 wanted 33999 found 36704
> [  187.015764] btrfs: open_ctree failed

uname now reports:

> Linux veriton 3.3.0-030300rc4-generic-pae #201202181935 SMP Sun Feb 19 00:53:06 UTC 2012 i686 i686 i386 GNU/Linux

I'm not sure what to try next; or even how to get more diagnostic information. Please let me know what additional information I can provide; or if I should simply throw in the towel (not my first choice).

Thanks again.

--
Curtis Jones




On Feb 19, 2012, at 05.41.09, Chris Samuel wrote:

> Hi Curtis,
> 
> On Sunday 19 February 2012 13:47:35 Curtis Jones wrote:
> 
>> I don't want to push this too far in the direction of being an
>> Ubuntu support thread; but do you happen to know of any convenient
>> methods for installing a 3.2.x kernel on Ubuntu? I'd like to
>> minimize the chance of screwing up my existing Ubuntu
>> installation....
> 
> My suggestion would be (given the uname -a info you supplied showed
> you were running a PAE kernel):
> 
> 1) First become root with:
> 
> sudo -i
> 
> 2) Then download the current stable mainline kernel release:
> 
> wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.2.6-precise/linux-image-3.2.6-030206-generic-
> pae_3.2.6-030206.201202131435_i386.deb
> 
> 3) Install the deb package you just downloaded with:
> 
> dpkg -i ./linux-image-3.2.6-030206-generic-pae_3.2.6-030206.201202131435_i386.deb
> 
> Then you should be able to reboot into it.
> 
> If you want to get rid of it you reboot and pick the latest 3.0 kernel
> that grub offers you and then:
> 
> sudo -i
> apt-get remove --purge linux-image-3.2.6-030206-generic-pae
> 
> Hope this helps!
> 
> cheers,
> Chris
> -- 
> Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
> 
> This email may come with a PGP signature as a file. Do not panic.
> For more info see: http://en.wikipedia.org/wiki/OpenPGP

