From: Leho Kraav <leho@kraav.com>
Subject: Re: btrfs 3.2.2 -> 3.3.1 upgrade finally ate babies, some advice?
Date: Mon, 09 Apr 2012 17:44:10 +0300
Message-ID: <4F82F5BA.3080504@kraav.com>
References: <CAMVG2stk4skvQHCyKUzjV-WLJc8Emt0GjRBZBOK-_EJj4q-JYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMVG2stk4skvQHCyKUzjV-WLJc8Emt0GjRBZBOK-_EJj4q-JYA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09.04.2012 17:35, Daniel J Blueman wrote:
> Leho Kraav<leho<at>  kraav.com>  writes:
> []
>> Apr  8 02:46:11 s9 kernel: [  189.691778] attempt to access beyond end
>> of device
>> Apr  8 02:46:11 s9 kernel: [  189.691787] dm-3: rw=129, want=23361976,
>> limit=20967424
>
> I recently bumped into this too [1]. Liu Bo posted a patch for it [2],
> which tests out fine here. The workaround is to not mount with
> 'discard' until eg ~3.4-rc3 or later.
>
> [1] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16409
> [2] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16649

Oh wow, thanks. This sounds exactly like what happened. I got the 
livelock post off my search results, but the patch post doesn't seem to 
have any of the keywords I was looking for, since I had no idea it could 
be related to discards.

So can this become a problem earlier too, not only when the space used 
is approaching limits? If not, I think I should be good until 3.4:

$ sudo btrfs fi show
Label: 'S9-HOME'  uuid: 1ed06dbc-e1b7-433f-8d1b-19cf1f7756f1
	Total devices 1 FS bytes used 12.93GB
	devid    1 size 60.00GB used 20.04GB path /dev/dm-0

Label: 'S9-ROOT'  uuid: 6206dfce-afcf-4afe-9047-b1c88a7889fd
	Total devices 1 FS bytes used 8.75GB
	devid    1 size 30.00GB used 18.29GB path /dev/dm-1

I think I'd like to keep using "discard" for SSD still, unless a smart 
person says it's not particularly useful anyway.

So while I'm on 3.3, is the patch from gmane:16649 good enough to 
eliminate immediate dangers?

And is the previous filesystem still hosed for good then? Or mounting 
the images with -discard might help?
