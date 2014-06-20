Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48108 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaFTSWF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 14:22:05 -0400
Message-ID: <53A47BC4.8040406@canonical.com>
Date: Fri, 20 Jun 2014 14:21:56 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: greg@kroah.com, kamal.mostafa@canonical.com, luis.henriques@canonical.com,
        jslaby@suse.cz, clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v3.10.y][v3.11.y][v3.12.y][v3.13.y][v3.14.y][PATCH 1/1][V2]
 ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while
 DEBUG not defined
References: <cover.1403113867.git.joseph.salisbury@canonical.com>	 <a377cdb51b1a98e9fa6bffaa124502fc15c47903.1403113867.git.joseph.salisbury@canonical.com> <1403142759.23472.28.camel@deadeye.wl.decadent.org.uk> <53A4515C.8090103@canonical.com>
In-Reply-To: <53A4515C.8090103@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2014 11:21 AM, Joseph Salisbury wrote:
> On 06/18/2014 09:52 PM, Ben Hutchings wrote:
>> On Wed, 2014-06-18 at 14:32 -0400, Joseph Salisbury wrote:
>>> From: Sander Eikelenboom <linux@eikelenboom.it>
>>>
>>> BugLink: http://bugs.launchpad.net/bugs/1319457
>>>
>>> This (widely used) construction:
>>>
>>> if(printk_ratelimit())
>>> 	dev_dbg()
>>>
>>> Causes the ratelimiting to spam the kernel log with the "callbacks suppressed"
>>> message below, even while the dev_dbg it is supposed to rate limit wouldn't
>>> print anything because DEBUG is not defined for this device.
>>>
>>> [  533.803964] retire_playback_urb: 852 callbacks suppressed
>>> [  538.807930] retire_playback_urb: 852 callbacks suppressed
>>> [  543.811897] retire_playback_urb: 852 callbacks suppressed
>>> [  548.815745] retire_playback_urb: 852 callbacks suppressed
>>> [  553.819826] retire_playback_urb: 852 callbacks suppressed
>>>
>>> So use dev_dbg_ratelimited() instead of this construction.
>>>
>>> Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>
>>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>> (backported from commit b7a7723513dc89f83d6df13206df55d4dc26e825)
>>> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
>> It looks like you have combined the commit identified here with the
>> preceding:
>>
>> commit a5065eb6da55b226661456e6a7435f605df98111
>> Author: Tim Gardner <tim.gardner@canonical.com>
>> Date:   Wed Apr 9 11:30:44 2014 -0600
>>
>>     ALSA: usb-audio: Suppress repetitive debug messages from retire_playback_urb()
>>
>> They should not be squashed together like this.
>>
>> Ben.
>>
>>> ---
>>>  sound/usb/pcm.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
>>> index ca3256d..ede4b92 100644
>>> --- a/sound/usb/pcm.c
>>> +++ b/sound/usb/pcm.c
>>> @@ -1488,7 +1488,8 @@ static void retire_playback_urb(struct snd_usb_substream *subs,
>>>  	 * on two reads of a counter updated every ms.
>>>  	 */
>>>  	if (abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
>>> -		snd_printk(KERN_DEBUG "delay: estimated %d, actual %d\n",
>>> +		dev_dbg_ratelimited(&subs->dev->dev,
>>> +			"delay: estimated %d, actual %d\n",
>>>  			est_delay, subs->last_delay);
>>>  
>>>  	if (!subs->running) {
> Hi Ben,
>
> Thanks for the feedback.  Do you think it's best to cherry-pick these
> two commits?  If so, I'll do that and test.  If it all works, I can send
> a request to stable to cherry pick the commits and revert my backport.
>
> Thanks,
>
> Joe
>

Hi Ben,

I looked at this some more.   It seems like my v2 backport may be the
most suitable for the releases mentioned in the subject line, but I'd
like to get additional feedback.

The lines added by commit a5065eb just get removed by commit b7a77235. 
Also, if I apply commit a5065eb, it will also require a backport to pull
in just a piece of code(Remove snd_printk() and add dev_dbg()) from
another prior commit(0ba41d9).  No backport would be needed at all if I
cherry-pick 0ba41d9, but that commit seems to have too may changes for a
stable release.

Thanks,

Joe
