From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: New data=ordered code pushed out to btrfs-unstable
Date: Mon, 21 Jul 2008 15:23:33 -0400
Message-ID: <4884E235.1010206@gmail.com>
References: <1216398992.6932.36.camel@think.oraclecorp.com>	 <4880F87B.7020908@gmail.com>	 <1216411969.6932.70.camel@think.oraclecorp.com>	 <48811ABF.5010606@gmail.com>	 <1216428331.6932.82.camel@think.oraclecorp.com>	 <48832D42.6030204@redhat.com>	 <1216560741.6932.83.camel@think.oraclecorp.com>	 <488341CB.1010007@redhat.com>	 <1216652915.6932.113.camel@think.oraclecorp.com>	 <4884D578.7040901@redhat.com> <1216665311.6932.116.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: rwheeler@redhat.com, linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216665311.6932.116.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Mon, 2008-07-21 at 14:29 -0400, Ric Wheeler wrote:
>   
>> Chris Mason wrote:
>>     
>>> On Sun, 2008-07-20 at 09:46 -0400, Ric Wheeler wrote:
>>>   
>>>       
>>>>            
>>>>     
>>>>         
>>>>>>>>>> Just to kick the tires, I tried the same test that I ran last week on 
>>>>>>>>>> ext4. Everything was going great, I decided to kill it after 6 million 
>>>>>>>>>> files or so and restart.
>>>>>>>>>>         
>>>>>>>>>>             
>>>>>>>>>>                 
>>>>>>>>>>                     
>>>>>>> Well, it looks like I neglected to push all the changesets, especially
>>>>>>> the last one that made it less racey.  So, I've just done another push,
>>>>>>> sorry.  For the fs_mark workload, it shouldn't change anything.
>>>>>>>
>>>>>>> This code still hasn't really survived an overnight run, hopefully this
>>>>>>> commit will.
>>>>>>>
>>>>>>>           
>>>>>>>               
>>>>>> The test is still running, but slowly, with a (slow) stream of messages 
>>>>>> about:
>>>>>>         
>>>>>>             
>>> [ lock timeouts and stalls ]
>>>
>>>
>>> Ok, I've made a few changes that should lower overall contenion on the
>>> allocation mutex.  I'm getting better performance on a 3 million file
>>> run, please give it a shot.
>>>
>>> -chris
>>>
>>>   
>>>       
>> Hi Chris,
>>
>> After an update, clean rebuild & reboot, the test is running along and 
>> has hit about 10 million files. I still see some messages like:
>>
>> INFO: task pdflush:4051 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> pdflush       D ffffffff8129c5b0     0  4051      2
>>  ffff81002ae77870 0000000000000046 0000000000000000 ffff81002ae77834
>>  0000000000000001 ffffffff814b2280 ffffffff814b2280 0000000100000001
>>  0000000000000000 ffff81003f188000 ffff81003fac5980 ffff81003f188350
>>
>> but not as many as before.
>>
>> I will attach the messages file,
>>     
>
> I'll try running with soft-lockup detection here, see if I can hunt down
> the cause of these stalls.  Good to know I've made progress though ;)
>
> -chris
>
>   
This is an 8 core box, so it is might be more prone to hitting these 
things ;-)

ric

