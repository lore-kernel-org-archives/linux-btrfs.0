Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820Ab3H0V2b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 17:28:31 -0400
Message-ID: <521D19FA.4050805@redhat.com>
Date: Tue, 27 Aug 2013 16:28:26 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com> <521CFDD8.6030205@suse.com> <20130827205637.GM29654@localhost.localdomain> <521D14FF.9090604@suse.com> <521D184F.5060407@redhat.com> <521D1955.8000908@suse.com>
In-Reply-To: <521D1955.8000908@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 8/27/13 4:25 PM, Jeff Mahoney wrote:
> On 8/27/13 5:21 PM, Eric Sandeen wrote:
>> On 8/27/13 4:07 PM, Jeff Mahoney wrote:
>>> On 8/27/13 4:56 PM, Josef Bacik wrote:
>>>> On Tue, Aug 27, 2013 at 03:28:24PM -0400, Jeff Mahoney wrote:
>>>>> On 8/26/13 4:56 PM, Josef Bacik wrote:
>>>>>> One of the complaints we get a lot is how many BUG_ON()'s we have.  So to help
>>>>>> with this I'm introducing a kconfig option to enable/disable a new ASSERT()
>>>>>> mechanism much like what XFS does.  This will allow us developers to still get
>>>>>> our nice panics but allow users/distros to compile them out.  With this we can
>>>>>> go through and convert any BUG_ON()'s that we have to catch actual programming
>>>>>> mistakes to the new ASSERT() and then fix everybody else to return errors.  This
>>>>>> will also allow developers to leave sanity checks in their new code to make sure
>>>>>> we don't trip over problems while testing stuff and vetting new features.
>>>>>> Thanks,
>>>>>
>>>>> I don't think the complaint is so much about the number of BUG_ONs, but
>>>>> that there's no distinction between something that is supposed to be
>>>>> impossible and something that is improbable. The BUG_ONs to keep code
>>>>> correctness are good and are littered all over the kernel with positive
>>>>> results. The BUG_ONs that are there in place of real error handling
>>>>> served their purpose and need to be replaced.
>>>>>
>>>>> So, I don't know if it's a net win to compile the "good" BUG_ONs out of
>>>>> the code. Especially if a user runs into something strange yet familiar
>>>>> and the first response is "oh, huh, can you rebuild with asserts enabled?"
>>>>>
>>>>
>>>> Either I provide an option for it or distros do it themselves, this cuts out the
>>>> middle man.  I'd really rather they just be on all the time since they aren't
>>>> things we should hit anyway, but at least this way people have a choice.
>>
>>> Ok. With my distro hat on, I can tell you I'll be leaving them on. :)
>>
>>> -Jeff
>>
>> XFS also has XFS_WARN as a config option, which keeps all the assertions
>> in place, but printk's & backtraces w/o the icky BUG().  That might be
>> good to add as well, and perhaps best for a shipping distro (vs. a developer
>> debugging who might want to drop a core file when the assert trips).
> 
> Isn't that the distinction between BUG_ON and WARN_ON? If it's worth a
> BUG_ON, things should be bad enough (or could result in being bad
> enough) that we want to bail out.
> 
> -Jeff

Maybe; just FWIW here was Dave's rationale for xfs.  Right now btrfs
doesn't have the behavior-changing side effect (no BTRFS_DEBUG config)
though, so maybe the distinction is less important...

    xfs: introduce CONFIG_XFS_WARN
    
    Running a CONFIG_XFS_DEBUG kernel in production environments is not
    the best idea as it introduces significant overhead, can change
    the behaviour of algorithms (such as allocation) to improve test
    coverage, and (most importantly) panic the machine on non-fatal
    errors.
    
    There are many cases where all we want to do is run a
    kernel with more bounds checking enabled, such as is provided by the
    ASSERT() statements throughout the code, but without all the
    potential overhead and drawbacks.
    
    This patch converts all the ASSERT statements to evaluate as
    WARN_ON(1) statements and hence if they fail dump a warning and a
    stack trace to the log. This has minimal overhead and does not
    change any algorithms, and will allow us to find strange "out of
    bounds" problems more easily on production machines.
    
    There are a few places where assert statements contain debug only
    code. These are converted to be debug-or-warn only code so that we
    still get all the assert checks in the code.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>


-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSHRn5AAoJECCuFpLhPd7gpsQQAJlFGX/t9b/LASxSisiv/wdL
ZoQXHhCzxpzVVdsWstzOY0bVXw8vdsG2E+nmih2S6T7AzkoqPDoEnYE9CqpNQFFy
Ca/kJOcfE1T4mIwKZwLHATkJX0V/S6nY7jPa7xdcseie+1H7ldSPaM5Jb6fkvXg/
8lNPTikGeoRJdUwQN4xxNgsivITfJpl65Z+AVg5UAUqqUKZtYZLfVeAlyQFKvOyl
/am80yLLzhFODtV3GcWkaYcInBaB2AaVlqHrpTnf53gG9JGynyFjnZGlysz0flSs
wstNKLOon+wNBg1Dz0HrUSVma87g5hc1WtaZFC/qI3uHuoatsxOWxG6+LXZlr2CN
Jsq3ZwHHxOs4MLgyEYlSirpgKqn/aKA+J8O0mNlltBj2lpU2hKgPS7dmMw5o8VAM
1uei1er15eBlCY0uBncRXIcLEcXfRXo9b69ErQBIbCN7xrGyWdbZ/DVtElaFeImh
Lw+iBXebBbw6SCqCMZFc3vpYdF+9RP6shImBlsqxTzKs5M1gISrFtCF0GqOuPrWt
7jyrredhpKACAaOpxPW8UWh2vL+q51JWzzZKYE35Gy4M/8E64TQ0rYhLGj7x+TYU
FWYzpONK0x7XbmgtEKTutwi9w+vfSlMzFNpUavwFeTZIh8Dw1tEO3dBn59Rs9Oz8
Widxpe+hqz/qK/0O4rTb
=4nmO
-----END PGP SIGNATURE-----
