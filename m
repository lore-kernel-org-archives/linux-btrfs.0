From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: TRIM support
Date: Sat, 2 Jul 2011 23:40:46 +0100
Message-ID: <CAAeznTpwk=Vu6g1xpQSR_By-=o6Sy2=B4cCG97Md4kHRibf6qQ@mail.gmail.com>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com>
	<1309635918.3774.7.camel@nayuki>
	<CAAeznTrfX9u9YXAz31cjsR=qxqrsnaPHLjZxqTaO4SDVBicF6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAeznTrfX9u9YXAz31cjsR=qxqrsnaPHLjZxqTaO4SDVBicF6A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 2, 2011 at 11:39 PM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> On Sat, Jul 2, 2011 at 8:45 PM, Calvin Walton <calvin.walton@kepstin.ca> wrote:
>> On Sat, 2011-07-02 at 19:08 +0100, Leonidas Spyropoulos wrote:
>>> Hello,
>>>
>>> I just installed an archlinux with btrfs root partition and would like
>>> to set the correct mount properties
>>> Following this:
>>> https://wiki.archlinux.org/index.php/Solid_State_Drives
>>> it says there that I should use the discard mount parameter to enable TRIM.
>>>
>>> I would like to ask by using ssd mount parameter would TRIM be enabled?
>>> The SSD is Intel 320 Series 120Gb
>>
>> No, the "ssd" mount parameter has nothing to do with TRIM.
>>
>> The "ssd" mount parameter adjusts a couple of tuning parameters where
>> the default setting is designed to improve performance on spinning HDD,
>> and instead tunes for the random-access ability of an SSD.
>>
>> The ssd option is automatically enabled if the kernel detects that your
>> drive is an SSD (you can check with 'cat /proc/mounts').
>>
>> The discard option is not currently automatically enabled; I think there
>> may have been some performance issues in certain cases with drives that
>> have slow trim implementations. But feel free to give it a try.
>>
>> --
>> Calvin Walton <calvin.walton@kepstin.ca>
>>
>>

On the same system when I try to compile the btrfs-tools I get an error.
Since on the wiki you mention only the packages for Fedora and Debian,

Which are the requirements for the btrfs tools?

PS: AUR package is broken as well.

-- 
Caution: breathing may be hazardous to your health.
