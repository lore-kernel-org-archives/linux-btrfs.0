From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:149!
Date: Tue, 31 May 2011 09:56:09 -0400
Message-ID: <4DE4F379.707@redhat.com>
References: <201105051954.48405.whirm@gmx.com> <201105231357.41588.whirm@gmx.com> <4DDABADD.7090209@redhat.com> <201105301312.43460.whirm@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Elric Milon <whirm@gmx.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105301312.43460.whirm@gmx.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/30/2011 07:12 AM, Elric Milon wrote:
> On Monday 23 May 2011 21:51:57 Josef Bacik wrote:
>> On 05/23/2011 07:57 AM, Elric Milon wrote:
>>> On Monday 16 May 2011 18:28:49 you wrote:
>>>> On 05/16/2011 11:01 AM, Whirm wrote:
>>>>> On Monday 16 May 2011 16:11:19 Josef Bacik wrote:
>>>>>
>>>>>
>>>>> Sorry yes, I meant this is how I managed to get the corrupted
>>>>> filesystem.
>>>>>
>>>>> Ill try to break it again.
>>>>
>>>> Oh ok perfect, yeah I will try and do the same sort of things and see if
>>>> I can get it to happen as well.  Thanks,
>>>
>>> Great, btw, I tried to see if I can mount the corrupted filesystem with
>>> the patch you told me about applied, and it fails, here's the log:
>>>
>>> http://pastebin.com/raw.php?i=4Kfv927B
>>>
>>> That happens using 2.6.39-rc7+ from git with the following patch applied
>>> (its
>>
>>> the debug patch and the possible fix you told me about):
>> Ok so this is a different kind of corruption, wooo!  Can you apply this
>> debug patch and get me the output so we can try and fix this bit?  Thanks,
>>
>> Josef
>>
> 
> Sorry for the delay, here's the log:
> 
> http://pastebin.com/raw.php?i=zNqJVpA1
> 

Ok so you have a corrupt extent entry in your tree.  I will come up with
something so we deal with this case better than panicing.  Thanks for
running these debug patches,

Josef
