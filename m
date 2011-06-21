From: Josef Bacik <josef@redhat.com>
Subject: Re: Abysmal Performance
Date: Tue, 21 Jun 2011 11:18:30 -0400
Message-ID: <4E00B646.4060109@redhat.com>
References: <7da312412980843ba746e4e8809060f8@localhost> <20110621080058.GA29265@attic.humilis.net> <d16814520f76be9fb5650ce47b52e2e4@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Henning Rohlfs <x+btrfs@xehonk.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d16814520f76be9fb5650ce47b52e2e4@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2011 05:26 AM, Henning Rohlfs wrote:
> On Tue, 21 Jun 2011 10:00:59 +0200, Sander wrote:
>> Henning Rohlfs wrote (ao):
>>> - space_cache was enabled, but it seemed to make the problem worse.
>>> It's no longer in the mount options.
>>
>> space_cache is a one time mount option which enabled space_cache. Not
>> supplying it anymore as a mount option has no effect (dmesg | grep
>> btrfs).
> 
> I'm sure that after the first reboot after removing the flag from the
> mount options, the system was faster for a while. That must have been a
> coincidence (or just an error on my part).
> 

No, the space cache will make your system faster _after_ having been
enabled once.  The reason for this is because we have to build the cache
the slow way at first, and then after that we can do it the fast way.
What is probably happening is your box is slowing down trying to build
this cache.  Don't mount with clear_cache unless there is a bug in your
cache.  Let it do it's thing and stuff will get faster.  Thanks,

Josef
