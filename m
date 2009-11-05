From: miyamoto moesasji <miyamoto.31b@gmail.com>
Subject: Re: Unexpected ENOSPC on a SSD-drive after day of uptime,
	kernel?2.6.32-rc5
Date: Thu, 5 Nov 2009 23:07:27 +0000
Message-ID: <fe72f2c80911051507t7fbb95c0s2134bf2018a6a413@mail.gmail.com>
References: <fe72f2c80911051238y299bab12g5f4b878851a25f13@mail.gmail.com>
	 <20091105210234.GD22737@dhcp231-156.rdu.redhat.com>
	 <loom.20091105T214826-537@post.gmane.org>
	 <20091105215524.GA13953@localhost.localdomain>
	 <fe72f2c80911051437u4c79ff74nc7cd2c2ff8d45138@mail.gmail.com>
	 <20091105224303.GB13953@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091105224303.GB13953@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

I'm not 100% sure what is the correct answer.

This is a clean install, just installed this weekend so the system
itself has only been running with the 2.6.32-rc5 kernel, nothing older
than that and the drive itself was completely new/clean. However for
the install itself I've used SystemRescueCD which was using a 2.6.31.1
kernel. Hence the partitions have been formatted using the kernel
2.6.31.1 and that is also the kernel used during the install of the
system.

On 11/5/09, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Nov 05, 2009 at 10:37:10PM +0000, miyamoto moesasji wrote:
>> 1) Running btrfs-vol -b indeed does free up some space on the
>> completely full partition, but not much, just 1GB. However I can use
>> it again, so that is very helpful. Many thanks Josef!
>>
>> For completeness: After running it on sda5 and sda3:
>> Label: none  uuid: a12ac0e9-cbea-4acf-bb26-181146940714
>>         Total devices 1 FS bytes used 90.31MB
>>         devid    1 size 8.00GB used 6.42GB path /dev/sda5
>>
>> Label: none  uuid: 0a89100d-096d-4c67-b3c7-745c9b7c3dc5
>>         Total devices 1 FS bytes used 10.60GB
>>         devid    1 size 20.00GB used 18.99GB path /dev/sda3
>>
>> 2) However I would still like to point out that I find it very
>> surprising to see the amount of space taken up by data+meta-data,
>> which looks dangerous to me seeing how quickly I got into a disk full
>> situation while normal df indicated no problem whatsoever (if on root
>> I would basically have had a kernel panic). Is this really expected
>> behavior or is this a known problem already so no need to
>> trouble-shoot?
>>
>
> Have you been using btrfs since 2.6.32-rc3 or have you used it for a while
> now
> and just recently gone to a 2.6.32-rc kernel?  The reason I ask is because
> we
> did all sorts of things to try and make sure users didn't run out of space,
> which included being overly agressive about making sure there was plenty of
> metadata space.  The enospc patches that went into 2.6.32-rc3 (i think,
> somewhere in there) has made this much better and you shouldn't be seeing
> this
> bad of an imbalance towards metadata.  So, if this fs was created pre
> 2.6.32-rc3 then this is expected and unfortunate.  If this fs was post that
> time
> then this is a problem and we need to figure out whats wrong.  Thanks,
>
> Josef
>
